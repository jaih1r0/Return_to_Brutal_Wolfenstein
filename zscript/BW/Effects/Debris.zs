//
//  base class for debris actors, these will be cleaned whenever the nashgore cleaner is used
//
Class BW_Debris : actor
{
    override void postbeginplay()
    {
        super.postbeginplay();
        changestatnum(STAT_CASING);
    }
}