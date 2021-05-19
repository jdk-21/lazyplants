import { genSalt, hash } from "bcryptjs"

export interface PasswordHasher <T = string> {
    hashPassword(password: T): Promise<T>;
}

export class BcryptHasher implements PasswordHasher<string> {
    rounds: number = 10;
    async hashPassword(password: string){
        const salt = await genSalt(this.rounds);
        return await hash(password, salt);
    }
}
