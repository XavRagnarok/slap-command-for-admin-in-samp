#define COLOR_RED (0xdb1a1aFF)
#define COLOR_CYAN (0x1fe0ddFF)

#define SCMex SendClientMessageEx

CMD:slap(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1) // Your admin rank
	{
		return SCM(playerid, color, "You don't have permissions to use this command"); // defines you don't have permission to it.
	}

	new playerb, Float:x, Float:y, Float:z, string[100];
	if(sscanf(params, "u", playerb))
	{
	    return SCM(playerid, color, "Usage: /slap [id/name]"); // proper usage of cmd
	}

    if(playerb == INVALID_PLAYER_ID)
	{
		return SCM(playerid, color, "Player is not connected"); // checks if the player is connected
	}

	GetPlayerPos(playerb, Float:x, Float:y, Float:z);
	SetPlayerPos(playerb, x, y, z + 5);

	PlayerPlaySound(playerb, 1190, 0.0,0.0,0.0);

	SCMex(playerid, color, "You've just slapped %s", ReturnName(playerb));
	SCMex(playerb, color, "An Admin slapped you");
	return 1;
}

stock ReturnName(playerid, underScore = 1)
{
	new playersName[MAX_PLAYER_NAME + 2];
	GetPlayerName(playerid, playersName, sizeof(playersName));

	if(!underScore)
	{
		{
			for(new i = 0, j = strlen(playersName); i < j; i ++)
			{
				if(playersName[i] == '_')
				{
					playersName[i] = ' ';
				}
			}
		}
	}

	return playersName;
}

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[156]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 156
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}