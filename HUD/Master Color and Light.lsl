key owner;

integer glow = FALSE;

// Rainbow
vector BLACK = <0.0, 0.0, 0.0>;
vector RED = <1.0,0.0,0.0>;
vector ORANGE = <1.0, 0.502, 0.0>;
vector YELLOW = <1.0, 1.0, 0.0>;
vector GREEN = <0.0, 1.0, 0.0>;
vector BLUE = <0.0, 0.0, 1.0>;
vector INDIGO = <0.502, 0.0, 1.0>;
vector VIOLET = <1.0, 0.0, 1.0>;


// Pastel
vector MELON = <1.000, 0.678, 0.678>;
vector JASMINE = <1.0, 0.839, 0.522>;
vector PALE_YELLOW = <0.992, 1.0, 0.714>;
vector TEA_GREAN = <0.792, 1.0, 0.749>;
vector BABY_BLUE = <0.627, 0.769, 1.0>;
vector VODKA = <0.741, 0.698, 1.0>;
vector LAVENDER = <1.0, 0.776, 1.0>;

list rainbow = ["RED","ORANGE", "YELLOW", "GREEN","BLUE", "INDIGO","VIOLET"];

list pastel = ["MELON","JASMINE","PALE YELLOW","TEA GREEN", "BABY BLUE", "VODKA", "LAVENDER"];


integer menu_chan; // chan to set modifiers
integer menu_handle;
integer text_chan;
integer text_handle;
integer time_chan;
integer time_handle;
integer obj_chan;
integer switch_chan;
integer switch_handle;
integer rainbow_chan;
integer rainbow_handle;
integer pastel_chan;
integer pastel_handle;
integer settings_chan;
integer settings_handle;


string touched;
string vec_1;
string vec_2;

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) +
        llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

integer menuindex;

DialogPlus(key avatar, string message, list buttons, integer channel, integer CurMenu)
{
    if (12 < llGetListLength(buttons))
    {
        list lbut = buttons;
        list Nbuttons = [];
        if(CurMenu == -1)
        {
            CurMenu = 0;
            menuindex = 0;
        }

        if((Nbuttons = (llList2List(buttons, (CurMenu * 10), ((CurMenu * 10) + 9)) + ["Back", "Next"])) == ["Back", "Next"])
            DialogPlus(avatar, message, lbut, channel, menuindex = 0);
        else
            llDialog(avatar, message,  order_buttons(Nbuttons), channel);
    }
    else
        llDialog(avatar, message,  order_buttons(buttons), channel);
}  // Code by Ugleh Ulrech from the wiki page https://wiki.secondlife.com/wiki/DialogPlus

Timer()
{
  
  llSetTimerEvent(0.0); 
  llSetTimerEvent(120.0);   
    
}

Listen()
{
  Rem();
   menu_handle = llListen(menu_chan,"",owner,"");
   Timer();   
    
}

Rem()
{
    
     llListenRemove(menu_handle);
     llListenRemove(text_handle);
     llListenRemove(time_handle);
     llListenRemove(switch_handle);
     llListenRemove(rainbow_handle);
     llListenRemove(pastel_handle); 
     llListenRemove(settings_handle);    
    
}

Menu()
{
  
  Listen();
   llDialog(owner, "\nSelect an option:\n", order_buttons(["Off","Settings","Time","Color","Color Fade","Color Strobe", "Glow", "Glow Fade", "Light", "Light Fade", "Rainbow Mode", "Pastel Mode"]), menu_chan);
  // 
   
       
}

Color_Menu(string m, integer p)
{
    Listen(); 
    DialogPlus(owner,m, ["CUSTOM","BLACK"]+rainbow+pastel, menu_chan, menuindex = p);
    
}

Rainbow_Menu()
{
   Rem();
   rainbow_handle = llListen(rainbow_chan,"","",""); 
    llDialog(owner,"\nSelect the rainbow effect:\n", order_buttons(["Rainbow Fade","Rainbow Strobe","Light Fade","Light Strobe","Light Off","Back"]), rainbow_chan);
    
   Timer(); 
}

Pastel_Menu()
{
   Rem();
   pastel_handle = llListen(pastel_chan,"","",""); 
    llDialog(owner,"\nSelect the pastel effect:\n", order_buttons(["Pastel Fade","Pastel Strobe","Light Fade","Light Strobe","Light Off","Back"]), pastel_chan); 
    
   Timer(); 
}

Time_Menu()
{
    Rem();
    time_handle = llListen(time_chan,"",owner,"");
      llDialog(owner,"\nSelect to change the fade time or the wait time. \n\nFade time is the time between transitioning between two colors.\n\nFor example if you set fade time to 3.0, it will take 3 seconds to fade between red and green.\n\nWait time is the time a color stays on a prim when fading or strobing before transitioning to the next color.\n\nFor example setting wait time to 15 seconds will make the prim red for 15 seconds, then transition for fade time to green and then stay on green for 15 seconds.\n\n", ["Fade Time","Wait Time","Back"], time_chan);
    Timer();  
}

Settings_Menu()
{
   Rem(); 
   settings_handle = llListen(settings_chan, "", owner,"");

 llDialog(owner,"\nSelect to change the glow, light and full bright properties of the prim.", order_buttons(["Glow","Light Intensity","Light Radius","Light Falloff","Full Bright","Back"]), settings_chan); 
    Timer();
    
}


integer isVector(string s)
{
    list split = llParseString2List(s, [" "], ["<", ">", ","]);
    if(llGetListLength(split) != 7)
        return FALSE;
    return !((string)((vector)s) == (string)((vector)((string)llListInsertList(split, ["-"], 5))));
    
} // code snippet by Strife Onizuka from the wiki page https://wiki.secondlife.com/wiki/Category:LSL_Vector

integer isFloat(string sin)
{
    sin = llToLower(sin);
    // Avoid run time fail (for lslEditor at least) if string looks remotely like scientific notation 
    if (llSubStringIndex(sin, "e") != -1)       return FALSE;     
    list temp = llParseStringKeepNulls(sin, ["."], [] );
    string subs = llList2String(temp, 0);
    if ( (string) ( (integer) subs) != subs)    return FALSE;
    if ( (temp != []) > 2)                      return FALSE;
    if ( (temp != [])== 2)
    {
    subs = llList2String(temp, 1);    // extract the decimal part
        // must have no sign after DP, so handle first decimal discretely
    string first = llGetSubString(subs, 0, 0);
    if ( (string) ( (integer) first) != first)     return FALSE;  
    if ( (string) ( (integer) subs)  != subs)      return FALSE;
    }
    return TRUE;
} // code snippet from https://wiki.secondlife.com/wiki/Category:LSL_Float

Switch_Menu(string m)
{
    Rem();
    switch_handle = llListen(switch_chan,"",owner,"");
      llDialog(owner,m, ["On","Off"], switch_chan);
    Timer();  
    
}


default
{
    
    on_rez(integer start_param)
    {
       
          llResetScript();  
           
       
        
    }
    
    
    state_entry()
    {
        
        owner = llGetOwner();
        
        menu_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) - 3257) | 0x8000000;
        text_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) - 2257) | 0x8000000;
        obj_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) - 777) | 0x8000000;
        time_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) -  8463) | 0x8000000;
        switch_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) -  7948) | 0x8000000;
        rainbow_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) -  7694248) | 0x8000000;
        pastel_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) -  727835) | 0x8000000;
       settings_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) -  73884) | 0x8000000;
       
       
       
    }
    
    
    
    touch_end(integer num)
    {
         
        
        Menu();
           
    }
    
    
     listen( integer chan, string name, key id, string msg)
    {
        if(chan == menu_chan)
        {
          msg = llToLower(msg);
         
          if(msg == "color"  || msg == "color fade" || msg == "color strobe")
          {
              touched = msg;   
              vec_1 = "";
              vec_2 = "";
              Color_Menu( "\nSelect a color:\n",menuindex = 0);
              
          } 
          
           else if(msg == "glow")
            {
                touched = msg;
               
               
               
                
                Switch_Menu("\nSelect to switch GLOW on or off,"); 
                
            }
            
             else if(msg == "glow fade")
            {
                touched = msg;
               
               
               
                
                Switch_Menu("\nSelect to switch GLOW FADE on or off,"); 
                
            }
            
            else if(msg == "light")
            {
                touched = msg;
               
               
               
                
                Switch_Menu("\nSelect to switch LIGHT on or off,"); 
                
            }
            
            
            else if(msg == "light fade")
            {
                touched = msg;
               
               
               
                
                Switch_Menu("\nSelect to switch LIGHT FADE on or off,"); 
                
            }
            
            else if(msg == "rainbow mode")
            {
              touched = msg;  
                
              Rainbow_Menu();
                
            }
            
             else if(msg == "pastel mode")
            {
              touched = msg;  
                
              Pastel_Menu();
                
            }
          
            
           else if(msg == "next")
        {
            
            Color_Menu("\nSelect a color:\n",++menuindex);
        }

        
        else if(msg == "back")
        {
            if(menuindex == 0)
            Menu();
            
            else
            Color_Menu("\nSelect a color:\n",--menuindex);
            
        }
        
        else if(msg == "off")
        {
            
           llRegionSay(obj_chan,"SWITCH_OFF"); 
            
        }
        
        else if(msg == "time")
        {
           Time_Menu(); 
            
        }
        
        else if(msg == "settings")
        {
          
          Settings_Menu();  
            
            
        }
        
        else
        {
            
           if(msg != "custom")
           {
               
            
           if(touched == "color")
           {
              
               llRegionSay(obj_chan,"CHANGE_COLOR|"+msg);
              Color_Menu("\nSelect a color:\n",menuindex);
               
           }
           
            else if(touched == "color fade" || touched == "color strobe" || touched == "light fade")
           {
              if(vec_1 == "" && vec_2 == "")
              { 
                  vec_1 = msg;
                  llOwnerSay("First color set to: " + vec_1+".");
                  Color_Menu("\nSelect a second color:\n",menuindex);
                  llOwnerSay("Select a second color.");
              } 
              
              else if(vec_1 != "" && vec_2 == "")
              { 
                  vec_2 = msg;
                  llOwnerSay("Second color set to: " + vec_2+".");
                 
                  if(touched == "color fade")
            {
              
               llRegionSay(obj_chan,"COLOR_FADE|"+vec_1+"*"+vec_2); 
               
              
                
            } 
            
            else if(touched == "color strobe")
            {
              
               llRegionSay(obj_chan,"COLOR_STROBE|"+vec_1+"*"+vec_2); 
               
               
                
            }
            
            
             else if(touched == "light fade")
            {
              
               llRegionSay(obj_chan,"LIGHT_FADE_ON|"+vec_1+"*"+vec_2); 
               
                
                
            }
            
            vec_1 = "";
               vec_2="";
             Menu(); 
                 
              } 
               
             
               
           }
           
           
           
            else if(touched == "light")
            {
              
             llRegionSay(obj_chan,"LIGHT_ON|"+msg);
                
            }
           
           
           } //  if(msg != "custom")
           
           else
           {
               
             Rem();
             text_handle = llListen(text_chan,"",owner,"");   
             llTextBox(owner, "Please input a color vector: \n", text_chan);
             Timer();
               
           } 
           
        }
            
            
            
        }   // chan == menu_chan
        
        else if(chan == switch_chan)
        {
            
           if(touched == "glow") 
           {
                if(msg == "On")
                {
                  
                  glow = TRUE;
                   llRegionSay(obj_chan,"GLOW_ON");  
                  
                }
            
            else if(msg == "Off")
                {
                
                  glow = FALSE;
                   llRegionSay(obj_chan,"GLOW_OFF");
                   
                }
               
            }              
                
              
          else if(touched == "glow fade") 
           {
                if(msg == "On")
                {
                  
                  glow = TRUE;
                      
              llRegionSay(obj_chan,"GLOW_FADE_ON|"+msg);
            
           
                }
            
            else if(msg == "Off")
                {
                
                  glow = FALSE;
                   llRegionSay(obj_chan,"GLOW_FADE_OFF");
                   
                }
               
            }
            
            
            else if(touched == "light") 
           {
                if(msg == "On")
                {
                  
              vec_1 = "";
              vec_2 = "";
              Color_Menu( "\nSelect a color:\n",menuindex = 0);
                  
                   
                  
                }
            
            else if(msg == "Off")
                {
                
                  
                   llRegionSay(obj_chan,"LIGHT_OFF");
                   
                }
               
            }
            
            
            else if(touched == "light fade") 
           {
                if(msg == "On")
                {
                   vec_1 = "";
              vec_2 = "";
              Color_Menu( "\nSelect a color:\n",menuindex = 0);
                  
                   
                  
                }
            
            else if(msg == "Off")
                {
                
                 
                   llRegionSay(obj_chan,"LIGHT_FADE_OFF");
                   
                }
               
            }
            
        }
        
        
        else if(chan == text_chan)
        {
           
              msg = llStringTrim(msg,STRING_TRIM);
              
             if(isVector(msg) == FALSE)
             { 
                llOwnerSay("That was not a valid vector. Please input a color vector.");
                 llTextBox(owner, "That was not a valid vector. Please input a color vector: \n", text_chan);
              Rem();
             text_handle = llListen(text_chan,"","","");
             Timer();   
                 
             }
             
             else
             {
                 
               if(touched == "color")
               {  
               
                llRegionSay(obj_chan,"CHANGE_COLOR|"+msg);
              Color_Menu("\nSelect a color:\n",menuindex);
               
               } 
               
               
                else if(touched == "color fade" || touched == "color strobe" || touched == "light fade")
           {
              if(vec_1 == "" && vec_2 == "")
              { 
                  vec_1 = msg;
                  llOwnerSay("First color set to: " + vec_1+".");
                  Color_Menu("\nSelect a second color:\n",menuindex);
                  llOwnerSay("Select a second color:");
              } 
              
              else if(vec_1 != "" && vec_2 == "")
              { 
                  vec_2 = msg;
                  llOwnerSay("Second color set to: " + vec_2+".");
                   if(touched == "color fade")
            {
              
               llRegionSay(obj_chan,"COLOR_FADE|"+vec_1+"*"+vec_2); 
               
               
                
            } 
            
            else if(touched == "color strobe")
            {
              
               llRegionSay(obj_chan,"COLOR_STROBE|"+vec_1+"*"+vec_2); 
              
              
                
            }
            
            
             else if(touched == "light fade")
            {
              
               llRegionSay(obj_chan,"LIGHT_FADE_ON|"+vec_1+"*"+vec_2); 
              
               
                
            }
            
            vec_1 = "";
               vec_2=""; 
            Menu(); 
            
              } 
               
             
               
           }
           
           
           
           
            if(touched == "light")
               {  
               
               llRegionSay(obj_chan,"LIGHT_ON|"+msg);
              Color_Menu("\nSelect a color:\n",menuindex);
               
               } 
           
           
                 
             } 
            
            
        } // else if(chan == text_chan)
        
         else if(chan == time_chan)
         {
           if(msg != "Fade Time" && msg != "Wait Time")
           {
               msg = llStringTrim(msg,STRING_TRIM);
              // float m = (float)msg;
              if(isFloat(msg) == TRUE)
              {
                  if(touched == "Fade Time")
                  llRegionSay(obj_chan,"Fade_Time|"+(string)((float)msg)); 
                  
                  else if(touched == "Wait Time")
                  llRegionSay(obj_chan,"Wait_Time|"+(string)((float)msg));
                  
              }
              
              else if(msg == "Back")
              Menu();
              
              else
              {
                llTextBox(owner, "\nThat was not a valid input. Please input the " + touched+ " in seconds. \n\nCan be a float or integer.\n",time_chan);
               Timer();  
                  
              }
              
               
               
           }
           
           else  
           {
               touched = msg;
               llTextBox(owner, "\nPlease input the " + msg+ " in seconds. \n\nCan be a float or integer.\n",time_chan);
               Timer();
               
               
            }
           
           
           
            
            
            
            
         }
         
         
         else if(chan == rainbow_chan)
         {
            if(msg != "Back")
            { 
             if(msg == "Rainbow Fade")
             llRegionSay(obj_chan,"RAINBOW_FADE|"+msg);
             else if(msg == "Rainbow Strobe")
              llRegionSay(obj_chan,"RAINBOW_STROBE");
              else if(msg == "Light Fade")
              llRegionSay(obj_chan,"RAINBOW_LIGHT_FADE");
              else if(msg == "Light Strobe")
              llRegionSay(obj_chan,"RAINBOW_LIGHT_STROBE"); 
              else if(msg == "Light Off")
               llRegionSay(obj_chan,"LIGHT_OFF");
               Rainbow_Menu();
               }
            
            else if(msg == "Back"){ 
              Rem();
             Menu();
             }
         }
         
          else if(chan == pastel_chan)
         {
              if(msg != "Back")
            {
             if(msg == "Pastel Fade")
             llRegionSay(obj_chan,"PASTEL_FADE|"+msg); 
             else if(msg == "Pastel Strobe")
              llRegionSay(obj_chan,"PASTEL_STROBE"); 
              else if(msg == "Light Fade")
              llRegionSay(obj_chan,"PASTEL_LIGHT_FADE"); 
               else if(msg == "Light Strobe")
              llRegionSay(obj_chan,"PASTEL_LIGHT_STROBE");
              else if(msg == "Light Off")
               llRegionSay(obj_chan,"LIGHT_OFF");
               Pastel_Menu();
               }
              
              else if(msg == "Back"){ 
             Rem();
             Menu();
             }
         }
        
         
         else if(chan == settings_chan)
         {
             msg = llToLower(msg);
            if(msg == "glow")
            { 
             touched = msg;
             
             llTextBox(owner, "\nPlease input the glow intensity. \n\nCan be a float or integer from 0.01 - 1.0.\n",settings_chan);
             
             Timer();
            }
            
            else if(msg == "light intensity")
            { 
             touched = msg;
             
             llTextBox(owner, "\nPlease input the light intensity. \n\nCan be a float or integer from 0.01 - 1.0.\n",settings_chan);
             
             Timer();
            }
            
             else if(msg == "light radius")
            { 
             touched = msg;
             
             llTextBox(owner, "\nPlease input the light radius. \n\nCan be a float or integer from 0.01 - 20.0.\n",settings_chan);
             
             Timer();
            }
            
             else if(msg == "light falloff")
            { 
             touched = msg;
             
             llTextBox(owner, "\nPlease input the light falloff \n\nCan be a float or integer from 0.01 - 2.0.\n",settings_chan);
             
             Timer();
            }
            
            else if(msg == "full bright")
            {
                
               llRegionSay(obj_chan,"FULL_BRIGHT");  
                
            }
            
            else if(msg == "back")
            {
                
              Menu(); 
                
            }
            
            
            
            
            else
            {
                msg == llStringTrim(msg,STRING_TRIM);
              if(touched == "glow")
              {
                  if(isFloat(msg) == TRUE)
                  llRegionSay(obj_chan,"GLOW_INTENSITY|"+msg);  
                  else
                  {
                      
                    llTextBox(owner, "\nThat was not valid input. Please input the glow intensity. \n\nCan be a float or integer from 0.01 - 1.0.\n",settings_chan);
             
             Timer();   
                      
                  }
                  
              }   
              
              
               else if(touched == "light intensity")
              {
                  if(isFloat(msg) == TRUE)
                  llRegionSay(obj_chan,"LIGHT_INTENSITY|"+msg);  
                  else
                  {
                      
                    llTextBox(owner, "\nThat was not valid input. Please input the light intensity.. \n\nCan be a float or integer from 0.01 - 1.0.\n",settings_chan);
             
             Timer();   
                      
                  }
                  
              }     
              
               else if(touched == "light radius")
              {
                  if(isFloat(msg) == TRUE)
                  llRegionSay(obj_chan,"LIGHT_RADIUS|"+msg);  
                  else
                  {
                      
                    llTextBox(owner, "\nThat was not valid input. Please input the light radius. \n\nCan be a float or integer from 0.01 - 20.0.\n\n",settings_chan);
             
             Timer();   
                      
                  }
                  
              }  
              
              else if(touched == "light falloff")
              {
                  if(isFloat(msg) == TRUE)
                  llRegionSay(obj_chan,"LIGHT_FALLOFF|"+msg);  
                  else
                  {
                      
                    llTextBox(owner, "\nThat was not valid input. Please input the light falloff \n\nCan be a float or integer from 0.01 - 2.0.\n\n",settings_chan);
             
             Timer();   
                      
                  }
                  
              }    
              
                
                
            }
            
            
             
             
             
         }
         
         
    } // listen
    
    
    changed(integer change)
    {
        
     if(change & CHANGED_LINK)
     {
       
       llResetScript();  
         
     }   
        
    }
    
    timer()
    {
         
     llSetTimerEvent(0.0);
     Rem();
            
    } 
     
    
    
    
}



