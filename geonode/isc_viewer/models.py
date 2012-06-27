from django.contrib.gis.db import models

# date, lat, lon, smajaz, sminax, strike, depth, unc , mw, unc , s, mo, fac, auth ,  mpp  ,  mpr  ,  mrr  ,  mrt  ,  mtp  ,  mtt

class Measure(models.Model):
    date = models.DateTimeField(null=False, blank=False)
    lat = models.FloatField(null=False, blank=False)
    lon = models.FloatField(null=False, blank=False)
    the_geom = models.PointField(srid=4326, dim=2)
    smajaz = models.FloatField(null=True, blank=True)
    sminax = models.FloatField(null=True, blank=True)
    strike = models.FloatField(null=True, blank=True)
    depth = models.FloatField(null=True, blank=True)
    depth_unc  = models.FloatField(null=True, blank=True)
    mw = models.FloatField(null=True, blank=True)
    mw_unc  = models.FloatField(null=True, blank=True)
    s = models.CharField(max_length=1, choices=(('p', 'Mw proxy'), ('d', 'direct Mw computation')), default='', null=False, blank=True)
    mo = models.FloatField(null=True, blank=True)
    fac = models.FloatField(null=True, blank=True)
    auth = models.CharField(max_length=255, default='', null=False, blank=True)
    mpp = models.FloatField(null=True, blank=True)  
    mpr = models.FloatField(null=True, blank=True)  
    mrr = models.FloatField(null=True, blank=True) 
    mrt = models.FloatField(null=True, blank=True) 
    mtp = models.FloatField(null=True, blank=True) 
    mtt = models.FloatField(null=True, blank=True)

    def __unicode__(self):
        return "%s %s %s" % (self.date, self.lat, self.lon)


