#if defined n_arms_fix_include
  #endinput
#endif
#define n_arms_fix_include


/**
 * Called when it's safe to set arms.
 *
 * @param	client			client index
 * @return  no return
 */
forward void ArmsFix_OnArmsSafe(int client);

/**
 * Called when it's safe to set player model.
 *
 * @param	client			client index
 * @return  no return
 */
forward void ArmsFix_OnModelSafe(int client);

/**
 * Set default model & arms
 *
 * @param	client			client index
 * @return  no return
 */
native int ArmsFix_SetDefaults(int client);

/**
 * Has default arms?
 *
 * @param	client			client index
 * @return  true/false
 */
native int ArmsFix_HasDefaultArms(int client);


public SharedPlugin n_arms_fix_include_shared =
{
	name = "Arms Fix",
	file = "n_arms_fix.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
};
