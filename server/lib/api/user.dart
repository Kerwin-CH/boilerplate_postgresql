// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of 'api.dart';

// TODO load this from environment variable
final pwdHasher =
    MD5Hasher('kljdf83dflkgjdöloit49t45849turdklgsjöldf3459p809sdlkxjbvlkzdjs');

@Controller(path: '/account')
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
    Map<String, String> form = await ctx.bodyAsUrlEncodedForm();
    String username = form['username'];
    String password = form['password'];

    // Does an account with the username already exist?
    UserBean bean = await _makeBean(ctx);
    user = await bean.findByUsername(username);
    print(user);
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

    return Response.json({
      'msg': 'Successfully signed up! Check your email for confirmation code.'
    });
  }

  @Post(path: '/login')
  Future<void> login(Context ctx) async {
    Map<String, String> form = await ctx.bodyAsUrlEncodedForm();

    String username = form['username'];
    String password = form['password'];

    UserBean bean = await _makeBean(ctx);

    User user = await bean.findByUsername(username);

    if (user == null) throw Response(null, statusCode: 401);
    if (user.password != pwdHasher.hash(password))
      throw Response(null, statusCode: 401);

    Session session = await ctx.session;
    session['id'] = user.id;
  }

  @Post(path: '/logout')
  Future<void> logout(Context ctx) async {
    Session session = await ctx.session;
    session.remove('id');
  }
}
