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

--Types
export type ResponsePacket = {
	Code: number,
	Message: string,
}

--Functions
function ResponseModule.Pack(Response: ResponsePacket)
	local Success, Result = pcall(function()
		local Code = Response.Code
		local Message = Response.Message
		local MessageBytes = #Message
		local Buffer = buffer.create(3 + MessageBytes)
		buffer.writeu16(Buffer, 0, Code)
		buffer.writeu8(Buffer, 2, MessageBytes)
		buffer.writestring(Buffer, 3, Message)
		return Buffer
	end)
	if not Success then return ResponseModule.Pack {Code = ResponseModule.Codes.UnableToPack, Message = Result} end
	return Result
end

function ResponseModule.Unpack(EncodedBuffer: buffer)
	local ResponseCode = buffer.readu16(EncodedBuffer, 0)
	local ResponseMessageBytes = buffer.readu8(EncodedBuffer, 2)
	local ResponseMessage = buffer.readstring(EncodedBuffer, 3, ResponseMessageBytes)
	return {Code = ResponseCode, Message = ResponseMessage}
end

function ResponseModule.Return(Response: ResponsePacket)
	local CodeEnum = Response.Code
	local Message = Response.Message
	if typeof(CodeEnum) ~= "number" then
		return ResponseModule.Pack {Code = ResponseModule.Codes.NoCodeProvided}
	end
	if not ResponseModule.Messages[CodeEnum] then
		return ResponseModule.Pack {Code = ResponseModule.Codes.InvalidCode}
	end
	return ResponseModule.Pack(Response)
end
