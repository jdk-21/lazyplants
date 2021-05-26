import { TokenService } from '@loopback/authentication';
import { inject } from '@loopback/core';
import { HttpErrors } from '@loopback/rest';
import { securityId, UserProfile } from '@loopback/security';
import { promisify } from 'util';
import { TokenServiceBindings } from '../keys';

const jwt = require('jsonwebtoken');
const signAsync = promisify(jwt.sign);
const verifyAsync = promisify(jwt.verify);

export class JWTService implements TokenService{
    @inject(TokenServiceBindings.TOKEN_SECRET)
    public readonly jwtSecret: string;
    @inject(TokenServiceBindings.TOKEN_EXPIRES_IN)
    public readonly jwtExpiresIn: string;

    async generateToken(userProfile: UserProfile): Promise<string> {
        if (!userProfile) {
          throw new HttpErrors.Unauthorized('Error generating token : userProfile is null');
        }
        const userInfoForToken = {
          id: userProfile[securityId],
          name: userProfile.name,
          role: userProfile.role,
          publicAddress: userProfile.publicAddress,
        };
        // Generate a JSON Web Token
        let token: string;
        try {
          token = await signAsync(userInfoForToken, this.jwtSecret, {
            expiresIn: Number(this.jwtExpiresIn),
          });
        } catch (error) {
          throw new HttpErrors.Unauthorized(`Error encoding token : ${error}`);
        }

        return token;
      }

    async verifyToken(token: string): Promise<UserProfile> {
        if (!token) {
          throw new HttpErrors.Unauthorized(
            `Error verifying token : 'token' is null`,
          );
        }

        let userProfile: UserProfile;

        try {
          // decode user profile from token
          const decodedToken = await verifyAsync(token, this.jwtSecret);
          // don't copy over  token field 'iat' and 'exp', nor 'email' to user profile
          userProfile = Object.assign(
            {[securityId]: '', name: ''},
            {
              [securityId]: decodedToken.id,
              name: decodedToken.name,
              id: decodedToken.id,
              role: decodedToken.role,
            },
          );
        } catch (error) {
          throw new HttpErrors.Unauthorized(
            `Error verifying token : ${error.message}`,
          );
        }
        return userProfile;
      }
}
