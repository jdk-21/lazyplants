import {TokenService, UserService} from '@loopback/authentication';
import {BindingKey} from '@loopback/core';
import {User} from './models';
import {Credentials} from './repositories';
import {PasswordHasher} from './services/password-hash-service';


export namespace TokenServiceConstants {
  export const TOKEN_SECRET_VALUE = '123asdf5';
  //export const TOKEN_EXPIRES_IN_VALUE = '45'; //test
  export const TOKEN_EXPIRES_IN_VALUE = '1209600'; //seconds two weeks
}

export namespace TokenServiceBindings {
  export const TOKEN_SECRET = BindingKey.create<string>('authentication.jwt.secret',);
  export const TOKEN_EXPIRES_IN = BindingKey.create<string>('authentication.jwt.expiresIn',);
  export const TOKEN_SERVICE = BindingKey.create<TokenService>('services.authentication.jwt.tokenservice',);
}

export namespace PasswordHasherBindings {
  export const PASSWORD_HASHER = BindingKey.create<PasswordHasher>('service.hasher');
  export const ROUNDS = BindingKey.create<number>('services.hasher.rounds');
}

export namespace UserServiceBindings {
  export const USER_SERVICE = BindingKey.create<UserService<Credentials, User>>('services.user.service');
}
