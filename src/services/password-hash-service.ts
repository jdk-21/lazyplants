import {inject} from '@loopback/core';
import {compare, genSalt, hash} from "bcryptjs"
import {PasswordHasherBindings} from '../keys';

export interface PasswordHasher <T = string> {
    hashPassword(password: T): Promise<T>;
    comparePassword(providedPass: T, storedPass: T): Promise<boolean>;
}

export class BcryptHasher implements PasswordHasher<string> {
    @inject(PasswordHasherBindings.ROUNDS)
    public readonly rounds: number;
    async hashPassword(password: string){
        const salt = await genSalt(this.rounds);
        return await hash(password, salt);
    }

    async comparePassword(
        providedPass: string,
        storedPass: string,
      ): Promise<boolean> {
        const passwordIsMatched = await compare(providedPass, storedPass);
        return passwordIsMatched;
    }
}
