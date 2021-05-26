import {BootMixin} from '@loopback/boot';
import {ApplicationConfig} from '@loopback/core';
import {
  RestExplorerBindings,
  RestExplorerComponent,
} from '@loopback/rest-explorer';
import {RepositoryMixin} from '@loopback/repository';
import {OpenApiSpec, RestApplication} from '@loopback/rest';
import {ServiceMixin} from '@loopback/service-proxy';
import path from 'path';
import {MySequence} from './sequence';
import {BcryptHasher} from './services/password-hash-service';
import {MyUserService} from './services/user-service';
import {JWTService} from './services/jwt-service';
import {SECURITY_SCHEME_SPEC, SECURITY_SPEC} from './utils/security-spec';

export {ApplicationConfig};

export class LazyplantsApplication extends BootMixin(
  ServiceMixin(RepositoryMixin(RestApplication)),
) {
  constructor(options: ApplicationConfig = {}) {
    super(options);

    const spec: OpenApiSpec = {
      openapi: '3.0.0',
      info: {title: 'LazyPlants', version: '0.0.1'},
      paths: {},
      components: {securitySchemes: SECURITY_SCHEME_SPEC},
      servers: [{url: '/api'}],
      security: SECURITY_SPEC,
    };
    this.api(spec);

    // Set up Bindings
    this.setupBinding();

    // Set up the custom sequence
    this.sequence(MySequence);

    // Set up default home page
    this.static('/', path.join(__dirname, '../public'));

    // Customize @loopback/rest-explorer configuration here
    this.configure(RestExplorerBindings.COMPONENT).to({
      path: '/explorer',
    });
    this.component(RestExplorerComponent);

    this.projectRoot = __dirname;
    // Customize @loopback/boot Booter Conventions here
    this.bootOptions = {
      controllers: {
        // Customize ControllerBooter Conventions here
        dirs: ['controllers'],
        extensions: ['.controller.js'],
        nested: true,
      },
    };
  }
  setupBinding(): void {
    this.bind('service.hasher').toClass(BcryptHasher);
    this.bind('rounds').to(10);
    this.bind('services.user.service').toClass(MyUserService);
    this.bind('services.jwt.service').toClass(JWTService);
    this.bind('authentication.jwt.secret').to('1234567890abcdef');
    this.bind('authentication.jwt.expiresIn').to('7h');
  }
}
