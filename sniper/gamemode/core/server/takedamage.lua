-- AAAAAAA
hook.Add( 'EntityTakeDamage', 'TakeDamage', function( ent, dmg )
	if ent:IsPlayer( ) then
		local atk = dmg:GetAttacker( ); 
		
		if atk:IsPlayer( ) then
			if atk:Team( ) == ent:Team( ) then
				dmg:SetDamage( 0 )
			end
		end
	end
end )