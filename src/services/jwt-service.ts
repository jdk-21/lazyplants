import { inject } from '@loopback/core';
import { HttpErrors } from '@loopback/rest';
import { UserProfile } from '@loopback/security';
import { promisify } from 'util';

const jwt = require('jsonwebtoken');
const signAsync = promisify(jwt.sign);

export class JWTService {
    @inject('authentication.jwt.secret')
    public readonly jwtSecret: string;
    @inject('authentication.jwt.expiresIn')
    public readonly jwtExpiresIn: string;
    async generateToken(userProfile: UserProfile): Promise<string>{
        if(!userProfile){
            throw new HttpErrors.Unauthorized('Error while generating token: userprofile is null');
        }
        let token = '';
        try{
            token = await signAsync(userProfile, this.jwtSecret, {
                expiresIn: this.jwtExpiresIn,
            });
        }catch(err){
            throw new HttpErrors.Unauthorized(`error generating token ${err}`)
        }
        return token;
    }
} 
