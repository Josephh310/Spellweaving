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
