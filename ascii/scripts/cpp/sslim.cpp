#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>
#include <bits/stdc++.h>
#include <fstream>
#include "class_pub.hpp"

// Just get command line arguments, create a sslim class,
// then use the arguments.
int main(int argc, char* argv[]) 
{
	sslim sslim;
	
	
	if (argc <= 1) 
	{
		sslim.getHelp("NULL");
		return 1;
	}
	
	std::string switchArg = argv[1];
	std::string extraArg;
	
	if (argc >= 3)
	{
		extraArg = argv[2];
	}
	
	if (switchArg == "--getWorkspaces")
	{
		sslim.getWorkspacesLoop();
		return 0;
	} 
	else if (switchArg == "--getHelp")
	{
		sslim.getHelp("NULL");
		return 0;
	}
	else if (switchArg == "--getBluetooth")
	{
		sslim.getBluetoothInfo();
		return 0;
	}
	else if (switchArg == "--toggleBluetooth")
	{
		sslim.toggleBluetooth();
		return 0;
	}
	else if (switchArg == "--getBattery")
	{
		if (argc != 3)
		{
			sslim.getHelp("Invalid Option: \"\"");
			return 1;
		}
		else if (extraArg != "0" && extraArg != "1" && extraArg != "2")
		{
			std::string incorrectStr = "Invalid Option: \"" + extraArg + "\"";
			sslim.getHelp(incorrectStr);
			return 1;
		}
		sslim.getBatteryInfo(extraArg);
		return 0;
	}
	else if (switchArg == "--getNetwork")
	{
		sslim.getNetworkInfo();
		return 0;
	}
	else if (switchArg == "--toggleNetwork")
	{
		sslim.toggleNetwork();
		return 0;
	}
	else
	{
		std::string incorrectStr = "Invalid Option: \"" + switchArg + "\"";
		sslim.getHelp(incorrectStr);
		return 1;
	}
	
	return 0;
}
