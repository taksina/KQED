public class StringConv{

public date format(String s){
    String dt;
    Map<String,String> m = new Map<String, String>{'Jan'=>'01','Feb'=>'02','Mar'=>'03','Apr'=>'04',
    'May'=>'05','Jun'=>'06','Jul'=>'07','Aug'=>'08','Sep'=>'09','Oct'=>'10','Nov'=>'11','Dec'=>'12'};
    String[] st = s.split(' ');
    
    for(integer k=0;k<st.size();k++)
    System.debug(st[k]);
    String mo = m.get(st[1]);
    System.debug(mo);
    
    if(st[5].length()==4)
    dt = st[5]+'-'+mo+'-'+st[2] ;
    else if(st[5].length()>4)
    dt = st[3]+'-'+mo+'-'+st[2] ;
    System.debug(dt);
    date d = date.valueof(dt);
    system.debug(d);
    return d;
    }
    
public static testmethod void te(){
stringconv sc = new stringconv();
date d = sc.format('Fri Sep 17 00:00:00 MST 2010 ');
}
}