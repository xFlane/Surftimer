enum TierArray {
	String:TierMapName[255],
	TierMapTier
}

Handle TiersArray = null;

public void LoadTiers()
{
	if(TiersArray != null)
	{
		ClearArray(TiersArray);
	}
	SQL_TQuery(g_hDb, SQL_ReadAllTiers, "SELECT tier, mapname from ck_maptier", 1, DBPrio_Low);
	TiersArray = CreateArray(view_as<int>(TierArray));
}

public void SQL_ReadAllTiers(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == INVALID_HANDLE)
	{
		PrintToServer("[SURF DATABASE] %s", error);
	}
	if(SQL_GetRowCount(hndl))
	{
		any [] data_ = new any[TierArray];
		
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 1, data_[TierMapName], 255);
			data_[TierMapTier] = SQL_FetchInt(hndl, 0);
			
			PushArrayArray(TiersArray, data_);
		}
	}
}

public int Native_GetMapTier_g(Handle plugin, int numParams)
{
	char MapName[255];
	GetNativeString(1, MapName, 255);
	
	any [] data = new any[TierArray];
	for(int i=0; i < GetArraySize(TiersArray); i++)
	{
		GetArrayArray(TiersArray, i, data);
		
		if(StrEqual(data[TierMapName], MapName))
			return data[TierMapTier];
	}
	
	return -1;
}