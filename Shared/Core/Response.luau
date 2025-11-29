--[[
	@Title:
		Network response module
	@Author:
		Joseph (@BreakLoop)
	@Description:
		Uses conventional network response codes to encourage consistent client-server error handling.
		Compresses codes and messages into a buffer. Message has a maximum length of 255 characters due to the u8 used for length.
		Responses are 38% smaller when compressed into a buffer versus plaintext messages.
	@Usage:
		Sender (Server - Client):
			return Response.Return { Code = ..., Message = ... }
		Reciever (Client - Server):
			Response.Unpack(Response) -> { Code = ..., Message = ... }
]]

local ResponseModule = {}

--Values
ResponseModule.Format = ">I2s1"
ResponseModule.Codes = {
	--Successful responses
	Success = 200,
	Created = 201,
	Accepted = 202,
	--Error on the client's part
	BadRequest = 400,
	Unauthorized = 401,
	Forbidden = 403,
	Ratelimited = 429,
	--Error on the server's part
	ServerError = 500,
	Unavailable = 503,
	TimedOut = 504,
	--Response error
	NoCodeProvided = 600,
	InvalidCode = 601,
	UnableToPack = 602,
}
ResponseModule.Messages = {
	--Successful responses
	[200] = "Success",
	[201] = "Created",
	[202] = "Accepted",
	--Error on the client's part
	[400] = "BadRequest",
	[401] = "Unauthorized",
	[403] = "Forbidden",
	[429] = "Ratelimited",
	--Error on the server's part
	[500] = "ServerError",
	[503] = "Unavailable",
	[504] = "TimedOut",
	--Response error
	[600] = "NoCodeProvided",
	[601] = "InvalidCode",
	[602] = "UnableToPack"
}

