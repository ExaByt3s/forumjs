
class PersonalException {
    constructor(msg, ref_fn, cerror) {
        this.excp = {
            message: msg,
            reference: ref_fn,
            codError: cerror
        };
    }

    GetMessage() {
        return this.excp.message;
    }

    GetRef() {
        return this.excp.reference;
    }

    GetExceptionToJson() {
        return { codError: this.excp.codError };
    }
}

module.exports = {
	PersonalException
}
