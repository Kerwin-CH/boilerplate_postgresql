// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of 'api.dart';

// TODO load this from environment variable
final pwdHasher =
    MD5Hasher('kljdf83dflkgjdöloit49t45849turdklgsjöldf3459p809sdlkxjbvlkzdjs');

@Controller(path: '/api/account')
class UserAccountRoutes {
  Future<UserBean> _makeBean(Context ctx) async {
    final pg.PostgreSQLConnection db = await pool.injectInterceptor(ctx);
    final adapter = PgAdapter.FromConnection(db);
    return UserBean(adapter);
  }

  @PostJson(path: '/signup')

  /// Signup endpoint
  Future<void> signup(Context ctx) async {
    // Is a user already logged in?
    User user = await Authorizer.authorize<User>(ctx, throwOnFail: false);
    if (user != null)
      return Response.json({
        'msg': 'Already logged in as ${user.name}! Please logout before signup.'
      }, statusCode: 401);

    // Parse the signup form
    Map<String, dynamic> form = await ctx.bodyAsMap();
    String username = form['username'];
    String password = form['password'];

    // Does an account with the username already exist?
    UserBean bean = await _makeBean(ctx);
    user = await bean.findByUsername(username);
    if (user != null)
      return Response.json({'msg': 'Username $username already exists!'},
          statusCode: 401);

    // TODO validate

    // Create the user
    user = User(
        id: Ulid().toUuid(),
        name: username,
        password: pwdHasher.hash(password));
    await bean.insert(user);

    // Write response
    // Redirect if it is form request
    if (ctx.acceptsHtml) return Redirect(Uri.parse('/login/index.html'));
    // Otherwise return JSON
    return Response.json({
      'msg': 'Successfully signed up! Check your email for confirmation code.'
    });
  }

  @Post(path: '/login')

  /// Login endpoint
  Future<void> login(Context ctx) async {
    // Parse the login form
    Map<String, dynamic> form = await ctx.bodyAsMap();
    String username = form['username'];
    String password = form['password'];

    // Check if an account with [username] exists
    UserBean bean = await _makeBean(ctx);
    User user = await bean.findByUsername(username);
    if (user == null)
      throw Response.json({'msg': 'Username $username does not exist!'},
          statusCode: 401);

    // Check if password is correct
    if (user.password != pwdHasher.hash(password))
      throw Response.json({'msg': 'Incorrect password!'}, statusCode: 401);

    // Authorize the session
    Session session = await ctx.session;
    session['id'] = user.id;

    // Write response
    // Redirect if it is form request
    if (ctx.acceptsHtml) return Redirect(Uri.parse('/home/index.html'));
    // Otherwise return JSON
    return Response.json({
      'msg': 'Successfully signed up! Check your email for confirmation code.'
    });
  }

  @Post(path: '/logout')
  Future<void> logout(Context ctx) async {
    User user = await Authorizer.authorize<User>(ctx, throwOnFail: false);
    if (user == null)
      return Response.json({'msg': 'You must login in order to logout.'},
          statusCode: 401);

    Session session = await ctx.session;
    session.remove('id');
  }
}
