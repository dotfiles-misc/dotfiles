-- Launch "System Preferences", open the "Displays" options and change to the "Display" tab
tell application "System Preferences"
	activate
	set the current pane to pane id "com.apple.preference.displays"
	reveal anchor "displaysDisplayTab" of pane id "com.apple.preference.displays"
end tell

local indexToUse

-- Now lets make the necessary changes
tell application "System Events"
	tell window "Built-in Retina Display" of application process "System Preferences" of application "System Events"
		tell tab group 1

			-- Click the "Scaled" radio button
			click radio button "Scaled" of radio group 1

			tell radio group of group 1
				-- Click the radio button for the new scale option/index
				click radio button 5 -- 1920 x 1200
			end tell

		end tell
	end tell
end tell

-- Quit "System Preferences"
quit application "System Preferences"
