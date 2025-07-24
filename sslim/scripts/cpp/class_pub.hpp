#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>
#include <fstream>
#include <bits/stdc++.h>
#include "class_pri.hpp"

// Simple function to loop and wait through the above workspace function
int sslim::getWorkspacesLoop() 
{
	// Run it once to update sooner, making the workspaces not look so
	// weird
	sslim::getWorkspaces();
	
	while (true)
	{
		// Special command to wait until there's a movement of either:
		// - Changing of workspace focus
		// - Moving of windows to a different workspace
		
		// Also, content is captured by the getStdoutCmd() function to
		// not clog up the STD:OUT
		std::string tempWait = sslim::getStdoutCmd("bspc subscribe -c 1 desktop node_transfer");
		
		// After the workspace focus has changed/a window has moved
		// workspace, run the json workspace generator once.
		sslim::getWorkspaces();
	}
}

// Function to pull information about bluetooth
int sslim::getBluetoothInfo()
{
	// Define variables
	std::string finishBuf;
	
	std::string blueStatus;
	std::string blueIcon;
	std::string blueSpecial;
	
	// Should change these for proper library syscalls instead of
	// system() syscalls -> not worth it
	
	
	// Get raw bluetooth info from syscalls
	std::string bluetoothIsOn = sslim::getStdoutCmd("bluetoothctl show");
	std::size_t powerStateLoc = bluetoothIsOn.find("PowerState");
	
	// Erase unneeded parts of the raw info, to allow for easier processing.
	bluetoothIsOn.erase(0, powerStateLoc + 12);
	bluetoothIsOn.erase(bluetoothIsOn.begin() + 3, bluetoothIsOn.end());
	bluetoothIsOn.pop_back();
	
	// Assign content to the variables
	if (bluetoothIsOn == "of")
	{
		blueStatus = "Off";
		blueIcon = "󰂲";
	}
	else
	{
		blueStatus = "On";
		blueIcon = "󰂯";
	}
	
	// If-else statement to get bluetooth info if bluetooth is turned on
	if (blueStatus == "On")
	{
		int deviceConnected = system("bluetoothctl info > /dev/null");
		
		// If the device isn't connected, then return early.
		if (deviceConnected != 0)
		{
			blueSpecial = "Not connected";
			blueIcon = "󰂱";
			
			finishBuf = "[\"" + blueIcon + "\",\"" + blueStatus + "\",\"" + blueSpecial + "\"]";
			std::cout << finishBuf << std::endl;
			return 0;
		}
		
		// Otherwise, get more info about it
		std::string deviceConnectedInfo = sslim::getStdoutCmd("bluetoothctl info");
		std::size_t connectedInfoLoc = deviceConnectedInfo.find("Alias");
		
		// Remove uneeded parts of the info
		deviceConnectedInfo.erase(0, connectedInfoLoc);
		
		// Get the device name
		{
			std::vector<std::string> deviceConnectedInfoList = sslim::splitStr(deviceConnectedInfo, " ");
			blueSpecial = deviceConnectedInfoList[1];
		}
		
		// Remove uneeded extra padding
		for (int i = 0; i < 8; i++)
		{
			blueSpecial.pop_back();
		}
	}
	else
	{
		blueSpecial = "Turned Off";
	}
	
	// Finish formatting the buffer and print
	finishBuf = "[\"" + blueIcon + "\",\"" + blueStatus + "\",\"" + blueSpecial + "\"]";
	std::cout << finishBuf << std::endl;
	
	return 0;
}

int sslim::toggleBluetooth()
{
	// Should change these for proper library syscalls instead of
	// system() syscalls -> not worth it.
	
	std::string bluetoothIsOn = sslim::getStdoutCmd("bluetoothctl show");
	std::size_t powerStateLoc = bluetoothIsOn.find("PowerState");
	
	bluetoothIsOn.erase(0, powerStateLoc + 12);
	bluetoothIsOn.erase(bluetoothIsOn.begin() + 3, bluetoothIsOn.end());
	bluetoothIsOn.pop_back();
	
	if (bluetoothIsOn == "of")
	{
		sslim::getStdoutCmd("bluetoothctl power on");
		return 0;
	}
	sslim::getStdoutCmd("bluetoothctl power off");
	
	return 0;
}


int sslim::getBatteryInfo(std::string type)
{
	int batteryPercen = std::stoi( sslim::readFile("/sys/class/power_supply/BAT0/capacity") );
	std::string batteryStatus = sslim::readFile("/sys/class/power_supply/BAT0/status");
	
	if (type == "0")
	{
		if (batteryPercen > 80 || batteryStatus == "Charging")
		{
			std::cout << "battery-scale_green\n";
		}
		else if (batteryPercen > 31)
		{
			std::cout << "battery-scale_orange\n";
		}
		else
		{
			std::cout << "battery-scale_red\n";
		}
	}
	else if (type == "1")
	{
		if (batteryPercen < 30 && batteryStatus != "Charging")
		{
			std::cout << "battery-icon_red\n";
		}
		else if (batteryPercen < 45 && batteryStatus == "Charging")
		{
			std::cout << "battery-icon_green\n";
		}
		else
		{
			std::cout << "battery-icon\n";
		}
	}
	else if (type == "2")
	{
		if (batteryStatus == "Charging" || batteryStatus == "Full")
		{
			std::cout << "󱐋\n";
		}
		else if (batteryPercen < 30)
		{
			std::cout << "󱈸\n";
		}
	}
	else
	{
		std::cout << "Wadaheck\n";
		return 1;
	}
	
	return 0;
}


int sslim::getNetworkInfo()
{
	std::string finishBuf;
	
	std::string netStatus;
	std::string netIcon;
	std::string netSpecial;
	
	std::string netIsOn = sslim::getStdoutCmd("nmcli networking connectivity");
	
	if (netIsOn == "limited\n" || netIsOn == "full\n")
	{
		netStatus = "On";
		netIcon = "󰤨";
	}
	else
	{
		netStatus = "Off";
		netIcon = "󰤭";
	}
	
	if (netStatus == "On")
	{
		std::string rawSSIDStr = sslim::getStdoutCmd("nmcli c show --active");
		
		std::size_t loPos = rawSSIDStr.find("lo");
		std::size_t secondNewline = rawSSIDStr.find('\n', loPos);
		std::size_t firstNewline = rawSSIDStr.rfind('\n', loPos);
		
		rawSSIDStr.erase(firstNewline, secondNewline - firstNewline);
		
		std::size_t namePos = rawSSIDStr.find("NAME");
		secondNewline = rawSSIDStr.find('\n', namePos);
		firstNewline = 0;
		
		rawSSIDStr.erase(firstNewline, secondNewline - firstNewline + 1);
		
		std::vector<std::string> SSIDList = sslim::splitStr(rawSSIDStr, " ");
		
		netSpecial = SSIDList[0];
	}
	else
	{
		std::string loString = sslim::getStdoutCmd("nmcli c show --active");
		std::size_t findLo = loString.find("lo");
		
		if (findLo != std::string::npos)
		{
			netIcon = "󰤩";
			netStatus = "On";
			netSpecial = "Disconnected";
			
			finishBuf = "[\"" + netIcon + "\",\"" + netStatus + "\",\"" + netSpecial + "\"]";
			std::cout << finishBuf << std::endl;
			
			return 0;
		}
		netSpecial = "Turned Off";
	}
	
	
	finishBuf = "[\"" + netIcon + "\",\"" + netStatus + "\",\"" + netSpecial + "\"]";
	std::cout << finishBuf << std::endl;
	
	return 0;
}

int sslim::toggleNetwork()
{
	std::string netIsOn = sslim::getStdoutCmd("nmcli networking connectivity");
	
	std::string netInfo = sslim::getStdoutCmd("nmcli c show --active");
	std::size_t findInfo = netInfo.find("lo");
	
	if (netIsOn == "limited" || netIsOn == "full")
	{
		sslim::getStdoutCmd("nmcli networking off");
	}
	else
	{
		if (findInfo != std::string::npos)
		{
			sslim::getStdoutCmd("nmcli networking off");
			return 0;
		}
		sslim::getStdoutCmd("nmcli networking on");
	}
	
	return 0;
}
