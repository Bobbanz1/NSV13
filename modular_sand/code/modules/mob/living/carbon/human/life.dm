//Hyper change, adds cumdrip
/mob/living/carbon/human/Life()
    if(!(. = ..()))
        return
    if(cumdrip_rate > 0 && stat != DEAD)
        handle_creampie()
