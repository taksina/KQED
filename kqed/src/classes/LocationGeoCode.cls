public class LocationGeoCode {
    public class LatLong {
        public LatLong(String lat, String lng) {
            this.lat = Double.valueOf(lat);
            this.lng = Double.valueOf(lng);
        }
        public Double Lat {get; set;}
        public Double Lng {get; set;}
    }
    public static void updateGeoCode(Location__c oldLocation, Location__c location) {
        if( oldLocation == null || //insert
            oldLocation.street__c != location.Street__c ||
            oldLocation.city__c != location.city__c ||
            oldLocation.state__c != location.state__c ||
            oldLocation.postalCode__c != location.postalCode__c ) {
            String address = location.Street__c + ',' + location.city__c + ',' +    
                location.State__c + ' ' + ((location.PostalCode__c==null) ? ' ' : location.PostalCode__c);
            futureUpdateGeoCode(address, location.Id);  
        }   
    }
    @future (callout=true)
    private static void futureUpdateGeoCode(String address, Id locationId) {
        LatLong ll = getGeoCode(address);
        if(ll!=null) {
            Location__c location = [
                Select id, latitude__c, longitude__c From Location__c 
                Where id = : locationId Limit 1
                ];
            location.latitude__c = ll.lat;
            location.longitude__c = ll.lng;
            update location;            
        }       
    }
    public static LatLong getGeoCode( String address ) {
        try {
            String AppKey='Fmjtd%7Cluu7200zng%2C2a%3Do5-5z2al'; 
            
            HttpRequest httpRequest = new HttpRequest();
            String endpoint = 'http://www.mapquestapi.com/geocoding/v1/address?key=' + appKey + 
                '&location=' + EncodingUtil.urlEncode(address, 'UTF-8') + 
                '&inFormat=xml' +
                '&outFormat=xml' +
                '&thumbMaps=false' +
                '&maxResults=-1' ;
            System.debug('Encoded Url=' + endpoint);                
            httpRequest.setEndpoint(endpoint);
            httpRequest.setMethod('POST');
            httpRequest.setBody('request');
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            String responseBody = httpResponse.getBody();
            System.debug('geoCode=' + responseBody);  
            /**
             * Use XmlDom to get the first LatLng.
             */           
            XmlDom responseDom = new XmlDom(responseBody);
            XmlDom.Element latLng = responseDom.getElementByTagName('displayLatLng');
            String lat = latLng.getValue('lat');
            String lng = latLng.getValue('lng');
            System.debug('lat=' + lat + ' lng=' + lng); 
            LatLong latlong = new LatLong(lat,lng); 
            return latlong;                            
        }
        /**--------------------------------------------------------------------
        <response>
            <info>
                <statusCode>0</statusCode>
                <messages/>
                <copyright>
                    <imageUrl>http://tile21.mqcdn.com/res/mqlogo.gif</imageUrl>
                    <imageAltText>© 2010 MapQuest, Inc.</imageAltText>
                    <text>© 2010 MapQuest, Inc.</text>
                </copyright>
            </info>
            <results>
                <result>
                    <providedLocation>
                        <request></request>                 
                        <location>21pemberton,wayland,ma,01778</location>
                    </providedLocation>
                    <locations>
                        <location>
                            <street>21 Pemberton Rd</street>
                            <adminArea5 type="City">Wayland</adminArea5>
                            <adminArea3 type="State">MA</adminArea3>
                            <adminArea4 type="County">Middlesex County</adminArea4>
                            <postalCode>01778-4817</postalCode>
                            <adminArea1 type="Country">US</adminArea1>
                            <geocodeQuality>ADDRESS</geocodeQuality>
                            <geocodeQualityCode>L1CAA</geocodeQualityCode>
                            <dragPoint>false</dragPoint>
                            <sideOfStreet>N</sideOfStreet>
                            <displayLatLng>
                                <latLng>
                                    <lat>42.316886</lat>
                                    <lng>-71.367831</lng>
                                </latLng></displayLatLng>
                                <linkId>21996836</linkId>
                                <type>s</type>
                                <latLng>
                                    <lat>42.316886</lat>
                                    <lng>-71.367831</lng>
                                </latLng>
                            </location>
                        </locations>
                </result>
            </results>
            <options>
                <maxResults>-1</maxResults>
                <thumbMaps>false</thumbMaps>
                <ignoreLatLngInput>false</ignoreLatLngInput>
                <boundingBox/>
            </options>
        </response>
        **/
        catch (System.Calloutexception calloutExp) {
            throw calloutExp;
        }
        return null;
    }

}