# MediaServer-FFMPEG-Patcher

This patcher is designed to simplify the patching steps of the Synology MediaServer and bring DTS, TrueHD and EAC3 transcoding support.

### Also want to patch VideoStation ? [there you go](https://github.com/AlexPresso/videostation-ffmpeg-patcher)

## Dependencies
- DSM 6.2.2-24922 Update 4 (and above)
- SynoCommunity ffmpeg 4.2.1-23 (and above) ([help](https://synocommunity.com/#easy-install))

## Supported / Unsupported scenarios
- [DTS or EAC3 or TrueHD] + [Any non HEVC standard video format]: ✅
- [no DTS, no EAC3, no TrueHD] + [HEVC]: ✅
- [DTS or EAC3 or TrueHD] + [HEVC]: ⚠️ Not working on architectures where Advanced Media Extensions uses GStreamer for audio decoding (Please don't submit any more issue related to this scenario, I'm working on it, see [#33](https://github.com/AlexPresso/VideoStation-FFMPEG-Patcher/pull/33))

## Instructions
- Check that you meet the required [dependencies](https://github.com/AlexPresso/mediaserver-ffmpeg-patcher#dependencies)
- Install SynoCommunity ffmpeg ([help](https://synocommunity.com/#easy-install))
- Connect to your NAS using SSH (admin user required) ([help](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General_Setup/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet))
- Use the command `sudo -i` to switch to root user
- Use the [following](https://github.com/AlexPresso/mediaserver-ffmpeg-patcher#usage) command (Basic command) to execute the patch
- You'll have to re-run the patcher everytime you update MediaServer and DSM

## Usage
Basic command:  
`curl https://raw.githubusercontent.com/AlexPresso/mediaserver-ffmpeg-patcher/main/patcher.sh | bash`   
With options:  
`curl https://raw.githubusercontent.com/AlexPresso/mediaserver-ffmpeg-patcher/main/patcher.sh | bash -s -- <flags>`

| Flags | Required | Description                                                                     |
|-------|----------|---------------------------------------------------------------------------------|
| -a    | No       | Action flag: choose between patch or unpatch ; example: `-a patch`              |
| -b    | No       | Branch flag: allows you to choose the wrapper branch to use ; example `-b main` |                                                        
