# -N- Arms Fix

## Last updates:
**Update 1.5.5 (11.6. 2017):**
  + New native: ArmsFix_SetDefaultArms - force sets default arms
  + New cvar: sm_arms_fix_autospawn - Enable/disable auto spawn fix - You can manually use plugin natives in your plugin.
  
**Update 1.5 (14.5. 2017):**
  + New method for setting default skins
  + New natives: ArmsFix_HasDefaultArms, ArmsFix_SetDefaults
  + Compatible with most maps  
  + Code optimizations
  
**Update 1.2:**
  + Methods update
  + Default arms / models change
  
**Update 1.1:**
  + Syntax Updates
  + Added API for third-party SourceMod plugins

**Update 1.0:**
  + Init version
  + SM Skinchooser support
  
## Compatible plugins:
  
------------------

## FAQ:
**1. Why do I see overlaps arms/gloves in spect OR after maximizing game?**

  - Use version >= 1.5.5 and set **sm_arms_fix_autospawn "0"**
  - Call manually **ArmsFix_SetDefaults(client)** function before you set player arms in own plugin - see skin_changer.sp example in examples.
    
**2. Are all plugins supported?**
 
  - :white_check_mark: Yes, but the plugin **MUST** use our API in order to gain this plugin's functionality. This is up to the developer of each plugin to implement.
