import 'package:basic_registration/services/auth/auth_exceptions.dart';
import 'package:basic_registration/services/auth/auth_provider.dart';
import 'package:basic_registration/services/auth/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin eith', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out in not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedExeption>()),
      );
    });
    test('Should be able to be initialized', () async {
      await provider.initialise();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less two sec', () async {
      await provider.initialise();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'talgat@mail.com',
        password: 'moloko',
      );

      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPasswordUser = provider.createUser(
        email: 'take',
        password: 'talgat',
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final user = await provider.createUser(
        email: 'foo',
        password: 'foobazbar',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedExeption implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({required email, required password}) async {
    if (!isInitialized) {
      throw NotInitializedExeption();
    }
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required email, required password}) {
    if (!isInitialized) {
      throw NotInitializedExeption();
    }
    if (email == 'talgat@mail.com') throw UserNotFoundAuthException();
    if (password == 'talgat') throw WrongPasswordAuthException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false,
      email: '',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedExeption();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedExeption();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: '',
    );
    _user = newUser;
  }
}
