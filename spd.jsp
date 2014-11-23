<%@ page language="java" import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<%@ page language="java" import="java.text.*" %>
<%@ page import="static java.lang.System.out"%>
<%@ include file="con1.jsp"%>


<%!      	
        LinkedList <String> url_list = new LinkedList <String>();
		LinkedList  <String> crawled_url_list = new LinkedList<String>();
        
		
    public class manager
    {   
	    public String fetch_page(String main_url)
		{   String webPage="";  	
		   	    
            try 
		    {   String nextLine;   StringBuffer wPage;  
                 
                if( main_url.indexOf("indexCorpDir_dsf.jsp") >= 0 )
	                main_url = "http://www.drdo.gov.in/drdo/Hindi/dsforum/" + main_url.substring(main_url.lastIndexOf("pg=")+3,main_url.length()) ;
                    
            	URL siteURL = new URL (main_url);  
                URLConnection siteConn = siteURL.openConnection();  
               	BufferedReader in = new BufferedReader ( new InputStreamReader(siteConn.getInputStream() ) );  
                wPage = new StringBuffer(30*1024);  
                
				while ( ( nextLine = in.readLine() ) != null ) 
				{
                     wPage.append(nextLine); 
				}  
                 
				in.close();
				webPage = wPage.toString();    				
			
			} catch ( Exception e1 ) { return "NOT_FOUND" ; }
            
			return webPage;
        }
		
		public void fetch_all_content( String root_url )
		{   
		    String webPage = "",str="",arr_link[]=new String[1000];	
			int c_link = 0, flag = 0 ;
			
			webPage = fetch_page(root_url);
						
			String arr[] = new String [webPage.length()],arr2[] = new String [webPage.length()],arr3[] = new String [100000],arr4[] = new String [10000],arr5[] = new String [10000] ;
            arr = webPage.split(" ");    			
	        arr2 = webPage.split(" "); 
            arr3 = webPage.split(" ");	   			
	           		
            for(int i=0;i<arr2.length;i++)
		    { 
     		    if( arr2[i] != null && arr2[i].length()>10 && arr2[i].indexOf("value=\"") >= 0 && arr2[i].indexOf("\"") > arr2[i].indexOf("value=\"") )
				{   arr_link[c_link] = arr2[i].substring( arr2[i].indexOf("value=\"")+6,arr2[i].lastIndexOf("\"")).replace("\"","");			
				          	
					if(arr_link[c_link].substring(0,arr_link[c_link].length()).equals("ADE"))	
                        flag=1;
													 
			    	if(flag == 1 && arr_link[c_link].length()>0)									
					{   arr_link[c_link] = "http://www.drdo.gov.in/drdo/labs/" + arr_link[c_link] + "/Hindi/index.jsp?pg=homebody.jsp" ;
					   					 
					    if(arr_link[c_link].substring(0,arr_link[c_link].length()).equals("http://www.drdo.gov.in/drdo/labs/VRDE/Hindi/index.jsp?pg=homebody.jsp"))
					        break;
					     					
					    c_link++; 	
					}
						
				}  
								
			}
				c_link++;	 
				
			for(int i=0;i<arr.length;i++)
		    { 				
		 	    if( arr[i] != null && arr[i].indexOf("href=\"") >= 0 && arr[i].indexOf(".css") < 0 && arr[i].indexOf(".ico") < 0 && arr[i].indexOf("javascript:tenderLog1")<0 )
		        { 
				    arr_link[c_link]=arr[i].substring( arr[i].indexOf("href=\"")+5,arr[i].length()).replaceAll("\"","");
					 
   				    if( arr_link[c_link] != null && arr_link[c_link].indexOf("=>") >= 0 )
						arr_link[c_link] = arr_link[c_link].substring(0,arr_link[c_link].indexOf("=>"));

     				if( arr_link[c_link] != null && arr_link[c_link].indexOf(">") >= 0 )
					    arr_link[c_link] = arr_link[c_link].substring(0,arr_link[c_link].indexOf(">"));
										 					 
					if( arr_link[c_link].length()==1 &&  arr_link[c_link].substring(0,1).equals("#") )
					    arr_link[c_link]=arr_link[c_link].replace("#","");
					 
					if( arr_link[c_link].indexOf("print_content") >= 0 )
					   	arr_link[c_link]=arr_link[c_link].replace("print_content","");
					
					if( arr_link[c_link].indexOf("javascript:Clickheretoprint()") >= 0 )
					    arr_link[c_link] = arr_link[c_link].replace("javascript:Clickheretoprint()","#");
					
					if( arr_link[c_link].length() >25 && arr_link[c_link].substring(0,25).equals("viewTender.jsp?paramMicro"))
					    arr_link[c_link] ="http://www.drdo.gov.in/drdo/tenders/" +  arr_link[c_link];
									
                    if( arr_link[c_link].indexOf("http") < 0 && arr_link[c_link].length() > 0 && arr_link[c_link].indexOf("viewTender.jsp?tender") < 0 )
					   	arr_link[c_link] = "http://www.drdo.gov.in/drdo/Hindi/" + arr_link[c_link];
									 
		            c_link++;
         		}
			} 			

	    //###########   javascript header links fetching  ##########
        
		    if(webPage.indexOf("stm_bm")>=0)
		    {    String strr="";
		
	            strr = webPage.substring(webPage.indexOf("stm_bm"),webPage.lastIndexOf("stm_em();"));
	            arr4 = strr.split("stm");					 				  					

		        for( int i=0;i<arr4.length;i++ )
		        { 
			        if(arr4[i] != null )
				    {
			   		    if( arr4[i].indexOf("../")>=0 && arr4[i].indexOf("]")>arr4[i].indexOf("../") )
				        {   arr_link[c_link] = "http://www.drdo.gov.in/drdo/Hindi/" + arr4[i].substring(arr4[i].indexOf("../"),arr4[i].indexOf("]"));
		                    arr_link[c_link] =  arr_link[c_link].replace("\"",""); 
						    
							if( arr_link[c_link].indexOf(",")>0 )
						         arr_link[c_link] = "http://www.drdo.gov.in/drdo/Hindi/" + arr_link[c_link].substring(arr_link[c_link].indexOf("../"),arr_link[c_link].indexOf(","));
     											
					        c_link++;
					    }
				        
						if( arr4[i].indexOf("index.jsp?")>=0 && arr4[i].indexOf("]")>arr4[i].indexOf("index.jsp?")  )
				        {   arr_link[c_link] = "http://www.drdo.gov.in/drdo/Hindi/" + arr4[i].substring(arr4[i].indexOf("index.jsp?"),arr4[i].indexOf("]") );
				            arr_link[c_link] =  arr_link[c_link].replace("\"","");  
				            
							if( arr_link[c_link].indexOf(",")>0 ) 
				                 arr_link[c_link] = "http://www.drdo.gov.in/drdo/Hindi/" + arr_link[c_link].substring(arr_link[c_link].indexOf("index.jsp?"),arr_link[c_link].indexOf(",") );
		            					 
					        c_link++; 
				        } 
					}
                }
		    }
				         
		    for( int i=0;i<c_link;i++ )
		    { 
			    if( arr_link[i]!=null && arr_link[i].indexOf("..") >= 0 )
				{   
					    while( arr_link[i].indexOf("..") >= 0 )
   					        arr_link[i] = arr_link[i].replace(arr_link[i].substring(arr_link[i].indexOf("..")-6,arr_link[i].indexOf("..")+3),"");
				}
				
				if( arr_link[i]!=null && !url_list.contains(arr_link[i]) && !crawled_url_list.contains(arr_link[i]) && arr_link[i].indexOf("www.drdo.gov.in")>=0 )
		        {   
					if(arr_link[i].indexOf(".pdf")>=0 || arr_link[i].indexOf(".wmv")>=0 || arr_link[i].indexOf(".jsp")>=0 || arr_link[i].indexOf(".htm")>=0 || arr_link[i].indexOf(".html")>=0 || arr_link[i].indexOf(".jpg")>=0  )
					    url_list.addLast( arr_link[i] );
                }			
			}	
			
			
		}
    }	
%>
<%  
    int  i=0 , no_workers = 1; 
        manager worker[] = new manager[no_workers] ;
	     /*
        PreparedStatement pst1=null;
        pst1=con.prepareStatement("select * from crawledlinks");
        ResultSet rs1= null;
        rs1=pst1.executeQuery();	
		
		while(rs1.next())
            crawled_url_list.addLast(rs1.getString("link"));
	*/
        			   
 	    worker[0] = new manager();
		
		/*if(crawled_url_list.contains("http://www.drdo.gov.in/drdo/Hindi/index.jsp?pg=homebody.jsp"))		 
		    {   worker[0].fetch_all_content(crawled_url_list.getLast());
			    out.println(crawled_url_list.getLast());
			}
	    else
			    	   
		{
		    worker[0].fetch_all_content("http://www.drdo.gov.in/drdo/Hindi/index.jsp?pg=homebody.jsp");
		    crawled_url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/index.jsp?pg=homebody.jsp");  
 	
		    PreparedStatement p0=null;
            p0=con.prepareStatement("INSERT INTO crawledlinks (link) VALUES ('http://www.drdo.gov.in/drdo/Hindi/index.jsp?pg=homebody.jsp')");
            p0.executeUpdate();
			
		}
			*/
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=home.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=aims.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=lecture.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=nsd.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=result.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=ntd.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=event.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=commitee.jsp");
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=photo.jsp");   
		url_list.addLast("http://www.drdo.gov.in/drdo/Hindi/dsforum/indexCorpDir_dsf.jsp?pg=contact.jsp");
		
		int x=1,flag1=0;
		
		while( url_list !=null && !url_list.isEmpty())        
		{   i=0;
		    			
			while( i < no_workers )
			{   
			   	worker[i] = new manager();
				String s = "";
				try{
				
				s = url_list.getFirst();
			    url_list.removeFirst();
				out.println(x+") "+s+"<br><hr>");
				x++;
				
			    if( s.equals("http://www.drdo.gov.in/drdo/labs/RAC/Hindi/index.jsp?pg=homebody.jsp") )
				{
				    if(url_list.size() > 0 && url_list.getFirst() != null )
					{   					    				 
					    s = url_list.getFirst();
				        url_list.removeFirst();
					}
					 
					if( !crawled_url_list.contains(s) && s != null)
			  	        crawled_url_list.addLast(s);
						
						out.println("<br> 1 <br>");
				}
				else                					  
				{   if( s.indexOf(".pdf")>=0 || s.indexOf(".wmv")>=0 || s.indexOf(".jpg")>=0 && !crawled_url_list.contains(s))
                    {
				    
					     PreparedStatement p3=null;
			             p3 = con.prepareStatement("INSERT INTO crawledlink ( link) VALUES ('"+s+"')");
                         p3.executeUpdate();
					     
					     out.println("<br> 2 <br>");				    
					     break;				     
			        }
					else{
                            if( !crawled_url_list.contains(s) )
			  	            {    				    
				                out.println(s);
								    crawled_url_list.addLast(s);
							       worker[i].fetch_all_content(s);
								   /*
                                     PreparedStatement pst0=null;
                                     pst0=con.prepareStatement("INSERT INTO crawledlink (link) VALUES ('"+s+"')");
                                     pst0.executeUpdate();
									*/						   
							         		   			   
				                worker[i].fetch_all_content(s);
               			        out.println("<br> 3 <br>");     			                
                            }
          		        }
				}		
			   
			    }catch( Exception e ){out.println(e); }
				i++;
            }
		}
   				
%>