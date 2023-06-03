// find out why when color strobe is on and rainbow strobe is on a color is skipping, going from red, yellow,blue, violet

// why when solid colour light stops changing if on fade

// if on solid colour or color fade and rainbow/pastel strobe is on it just changes to next color without switching light off in between


vector COL_1 = <1.0, 0.0, 0.0>;
vector COL_2 = <0.0, 1.0, 0.0>;
vector LIGHT_1 = <0.0, 1.0, 0.0>;
vector LIGHT_2 = <0.0, 0.0, 1.0>;
vector STROBE;


float fade_time = 3.0;
float wait_time = 15.0;
float ui_time = 0.044;
float glow_intensity = 0.3;
float light_intensity = 1.0; 
float light_radius = 10.0;
float light_falloff = 1.0;

string color_mode;
integer Forward;
vector Start;
vector End;
integer Fading; 
float iGlow;
vector lStart;
vector lEnd;
integer lStrobe;
integer listening;


// Rainbow
vector BLACK = <0.0, 0.0, 0.0>;
vector RED = <1.0,0.0,0.0>;
vector ORANGE; // can set it as <1.0, 0.502, 0.0> but better to set it with hex value in state_entry
vector YELLOW = <1.0, 1.0, 0.0>;
vector GREEN = <0.0, 1.0, 0.0>;
vector BLUE = <0.0, 0.0, 1.0>;
vector INDIGO; // can set it as <0.502, 0.0, 1.0> but better to set it with hex value in state_entry
vector VIOLET; // can set it as <1.0, 0.0, 1.0> but better to set it with hex value in state_entry


// Pastel
vector MELON = <1.000, 0.678, 0.678>;
vector JASMINE = <1.0, 0.839, 0.522>;
vector PALE_YELLOW = <0.992, 1.0, 0.714>;
vector TEA_GREAN = <0.792, 1.0, 0.749>;
vector BABY_BLUE = <0.627, 0.769, 1.0>;
vector VODKA = <0.741, 0.698, 1.0>;
vector LAVENDER = <1.0, 0.776, 1.0>;

list rainbow;

list pastel;

list colors;

integer l_chan; // chan to set modifiers
integer l_handle;
integer COLOR_ON;
integer GLOW_ON;
integer GLOW_FADE;
integer GLOW_STROBE;
integer LIGHT_ON;
integer LIGHT_FADE;
integer LIGHT_STROBE;
integer RAINBOW_STROBE; 
integer PASTEL_STROBE;
integer RAINBOW_LIGHT;
integer PASTEL_LIGHT;
integer RAINBOW_LIGHT_STROBE =FALSE;
integer PASTEL_LIGHT_STROBE =FALSE; 
integer FULL_BRIGHT;
integer lswrite;
integer ridx;
integer rlength;

key owner;


vector hex2rgb(string hex)
{
     if(llGetSubString(hex, 0, 0) == "#")
        hex = llGetSubString(hex, 1, 6);
    integer i = (integer)("0x" + hex);
    return <(i >> 16) & 0xFF, (i >> 8) & 0xFF, (i & 0xFF)> / 255;
}



integer Write(string kv, string val)
{
  
   return llLinksetDataWrite(kv,val);
    
}

string Read(string kv)
{
    
  return llLinksetDataRead(kv);
    
}

getColors(string r)
{
    
  llSetTimerEvent(0.0);   
            list col = llParseString2List(r,["*"],[]);
            
            
            
             integer idx = llListFindList(colors,[llToUpper(llList2String(col,0))]);
                vector vec;
               
               if(idx != -1) 
               vec = llList2Vector(colors,idx+1);
               
               else
               vec = (vector)llList2String(col,0); 
            
            COL_1 = vec;
          lswrite = Write("COL_1",(string)COL_1); 
            
            
            
            
            idx = llListFindList(colors,[llToUpper(llList2String(col,1))]);
             
               
               if(idx != -1) 
               vec = llList2Vector(colors,idx+1);
               
               else
               vec = (vector)llList2String(col,1);
            
            COL_2 = vec;
          lswrite = Write("COL_2",(string)COL_2); 
             
            //  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, COL_2 ,1.0]);
            
            
           
    
}



getLights(string r)
{
    
  llSetTimerEvent(0.0);   
            list col = llParseString2List(r,["*"],[]);
            
            
            
             integer idx = llListFindList(colors,[llToUpper(llList2String(col,0))]);
                vector vec;
               
               if(idx != -1) 
               vec = llList2Vector(colors,idx+1);
               
               else
               vec = (vector)llList2String(col,0); 
            
            LIGHT_1 = vec;
          lswrite = Write("LIGHT_1",(string)LIGHT_1); 
            
            
            
            
            idx = llListFindList(colors,[llToUpper(llList2String(col,1))]);
             
               
               if(idx != -1) 
               vec = llList2Vector(colors,idx+1);
               
               else
               vec = (vector)llList2String(col,1);
            
            LIGHT_2 = vec;
          lswrite = Write("LIGHT_2",(string)LIGHT_2); 
             
            //  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, COL_2 ,1.0]);
           
            
            
    
}




Blend(integer fwd)
{
// llOwnerSay("called blend");  
   if(COLOR_ON == TRUE)
   {
    if(color_mode == "COLOR_FADE" || color_mode == "COLOR_STROBE"|| color_mode == "RAINBOW_FADE"|| color_mode == "PASTEL_FADE")   
    {
    if(fwd)
    {
       
       if(color_mode == "RAINBOW_FADE")
       { 
     // llOwnerSay("forward" + (string)ridx);
        COL_2  = llList2Vector(rainbow,ridx); 
        }
        
        if(color_mode == "PASTEL_FADE")
       { 
      
        COL_2  = llList2Vector(pastel,ridx); 
        }
       Start = COL_1;
        End = COL_2; 
        
       // llOwnerSay((string)Start);
       //  llOwnerSay((string)End);
       
    } //  if(fwd)
    else 
    {
        
        
           
        Start = COL_2;
      
        if(color_mode == "RAINBOW_FADE")
       { 
       
    //  llOwnerSay("back" +(string)ridx);
        COL_1  =llList2Vector(rainbow,ridx);
        
       }
       
       else if(color_mode == "PASTEL_FADE")
       { 
       
      
        COL_1  = llList2Vector(pastel,ridx);
        
       }
      
        
        End = COL_1;
      
      
       
                
           
                   
    } //else backwards
    
     lswrite = Write("COL_1",(string)COL_1); 
     lswrite = Write("COL_2",(string)COL_2); 
    
    }  // if(color_mode
   } // if(COLOR_ON == TRUE)
   
   if(LIGHT_FADE == TRUE || RAINBOW_LIGHT == TRUE || PASTEL_LIGHT == TRUE)
   {
      
     
        if(fwd)
    {
       
       
        if(RAINBOW_LIGHT)
       { 
      
        LIGHT_2  = llList2Vector(rainbow,ridx); 
        }
        
        if(PASTEL_LIGHT)
       { 
      
        LIGHT_2  = llList2Vector(pastel,ridx); 
        }
       
      //  llOwnerSay("FORWARD" + (string)LIGHT_1);
      //  llOwnerSay("FORWARD" +(string)LIGHT_2);
       lStart = LIGHT_1;
        lEnd = LIGHT_2; 
    }
    else 
    {
       
        lStart = LIGHT_2;
        
         if(RAINBOW_LIGHT)
       { 
       
      
        LIGHT_1  =llList2Vector(rainbow,ridx);
        
       }
       
       else if(PASTEL_LIGHT)
       { 
       
      
        LIGHT_1  = llList2Vector(pastel,ridx);
        
       }
        
        
        
        lEnd = LIGHT_1;
        
       //  llOwnerSay("BACKWARD" + (string)LIGHT_1);
       // llOwnerSay("BACKWARD" + (string)LIGHT_2); 
    }
       
      lswrite = Write("LIGHT_1",(string)LIGHT_1); 
     lswrite = Write("LIGHT_2",(string)LIGHT_2);  
     
       
    }
   
   
    llResetTime();
    Fading = TRUE;
    llSetTimerEvent(ui_time);
}

Strobe(integer fwd)
{
 // llOwnerSay("CALLED STROBING");
  // llOwnerSay("called strobing light");
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, BLACK ,1.0,PRIM_GLOW,ALL_SIDES,0.0]);
  if(RAINBOW_LIGHT == FALSE && PASTEL_LIGHT == FALSE) 
   llSetLinkPrimitiveParamsFast(LINK_THIS,[ PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);
   
   if(color_mode == "COLOR_STROBE")
   { 
    if(fwd)
    {
        
        
        
        STROBE = COL_1;
        
    }
    else 
    {
         STROBE = COL_2;
        
    }
    }
    
    else if(color_mode == "RAINBOW_STROBE" || color_mode == "PASTEL_STROBE")
    {
      
        STROBE = COL_1;
        
    }
    
     else if(color_mode == "RAINBOW_STROBE" || color_mode == "PASTEL_STROBE")
    {
      
        STROBE = COL_1;
        
    }
    
 //  if(RAINBOW_LIGHT == TRUE || PASTEL_LIGHT== TRUE)
              //{
                
             //    Blend(Forward = !Forward);
                  
               // }
    
   
    llResetTime();
     Fading = TRUE;
    llSetTimerEvent(ui_time);
}


Light_Strobe()
{
 // llOwnerSay("CALLED LIGHT STROBE" + (string)ridx);
    
  // llSetTimerEvent(0.0); 
    if(RAINBOW_LIGHT_STROBE == TRUE)
     {
      LIGHT_1 = llList2Vector(rainbow,ridx);
       lswrite = Write("LIGHT_1", (string)LIGHT_1);
     //  llOwnerSay("light");
     llOwnerSay("light strobe");
       llSetLinkPrimitiveParamsFast(LINK_THIS,[ PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);
     }
    else if(PASTEL_LIGHT_STROBE == TRUE)
    {
      LIGHT_1 = llList2Vector(pastel,ridx);
      llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);
    }
    
   
   
    if(color_mode == "CHANGE_COLOR")
    {
        
    llResetTime();
    Fading = TRUE;
    llSetTimerEvent(ui_time);
    
    }
     
   
    
  // if(color_mode == "COLOR_STROBE")
 //  { 
   // if(fwd)
   // {
        
        
        
     //   STROBE = COL_1;
        
   // }
   // else 
    //{
       //  STROBE = COL_2;
        
   // }
   // }
    
     //if(color_mode == "RAINBOW_STROBE" || color_mode == "PASTEL_STROBE")
    //{
      
       // STROBE = COL_1;
        
  //  }
    
    // else if(color_mode == "RAINBOW_STROBE" || color_mode == "PASTEL_STROBE")
  //  {
      
       // STROBE = COL_1;
        
   // }
    
   
   
  //  llResetTime();
   // Fading = TRUE;
  //  llSetTimerEvent(ui_time);
} 




default
{
    on_rez(integer start_parama)
    {
       
        llResetScript();
        
    }
    
    state_entry()
    {
        llListenRemove(l_handle);
         owner = llGetOwner(); 
      
        
     /// assign colors below before adding them to the list   
        ORANGE = hex2rgb("#ffa500"); 
        INDIGO = hex2rgb("#4b0082");
        VIOLET = hex2rgb("#ee82ee");
        
        
        
        
        /// assign color lists above this line AFTER assigning colors, assign all colors above
        rainbow = ["RED",RED,"ORANGE",ORANGE,"YELLOW",YELLOW,"GREEN",GREEN,"BLUE",BLUE,"INDIGO",INDIGO,"VIOLET",VIOLET];

       pastel = ["MELON",MELON,"JASMINE",JASMINE,"PALE YELLOW",PALE_YELLOW,"TEA GREEN",TEA_GREAN, "BABY BLUE", BABY_BLUE, "VODKA", VODKA, "LAVENDER", LAVENDER];
        
       
        
        COLOR_ON = FALSE;
       llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, BLACK ,1.0,PRIM_GLOW,ALL_SIDES,0.0,PRIM_GLOW,ALL_SIDES,0.0, PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01,PRIM_FULLBRIGHT,ALL_SIDES,FALSE]); 
        
       colors = rainbow + pastel; 
      
       
       COLOR_ON = (integer)Read("COLOR_ON");
       
      
       color_mode = Read("color_mode");
       
       COL_1 = (vector)Read("COL_1");
       COL_2 = (vector)Read("COL_2");
       ridx = (integer)Read("ridx");
       
        
       
       LIGHT_1 = (vector)Read("LIGHT_1");
       LIGHT_2 = (vector)Read("LIGHT_2");
        GLOW_ON = (integer)Read("GLOW_ON");
        GLOW_FADE = (integer)Read("GLOW_FADE");
        GLOW_STROBE = (integer)Read("GLOW_STROBE");
         LIGHT_ON = (integer)Read("LIGHT_ON");
        LIGHT_FADE = (integer)Read("LIGHT_FADE");
        RAINBOW_LIGHT = (integer)Read("RAINBOW_LIGHT");
        PASTEL_LIGHT = (integer)Read("PASTEL_LIGHT");
        LIGHT_STROBE = (integer)Read("LIGHT_STROBE");
        RAINBOW_STROBE = (integer)Read("RAINBOW_STROBE");
        PASTEL_STROBE = (integer)Read("PASTEL_STROBE");
        RAINBOW_LIGHT_STROBE = (integer)Read("RAINBOW_LIGHT_STROBE");
        PASTEL_LIGHT_STROBE = (integer)Read("PASTEL_LIGHT_STROBE");
        wait_time = (float)Read("Wait_Time");
        fade_time = (float)Read("Fade_Time");
        glow_intensity = (float)Read("glow_intensity");
        light_intensity = (float)Read("light_intensity");
        light_radius = (float)Read("light_radius");
        light_falloff = (float)Read("light_falloff");
        FULL_BRIGHT = (integer)Read("full_bright");
        
        
        if(fade_time == 0.0)
        fade_time = 3.0;
        if(wait_time == 0.0)
        wait_time = 15.0;
        if(light_intensity == 0.0);
        light_intensity = 1.0;
        if(light_radius == 0.0);
        light_radius = 10.0;
        if(light_falloff == 0.0);
        light_falloff = 1.0;
        if(glow_intensity == 0.0);
        glow_intensity = 0.3;
        
        if (color_mode == "RAINBOW_FADE" || color_mode == "RAINBOW_STROBE" || RAINBOW_LIGHT == TRUE || RAINBOW_LIGHT_STROBE == TRUE)
               rlength = llGetListLength(rainbow);
        else if (color_mode == "PASTEL_FADE"  || color_mode == "PASTEL_STROBE" || PASTEL_LIGHT == TRUE || PASTEL_LIGHT_STROBE == TRUE)
               rlength = llGetListLength(pastel);
        
         if ( RAINBOW_LIGHT_STROBE == TRUE  || PASTEL_LIGHT_STROBE == TRUE)
         {
           Light_Strobe();  
             
         }
        
      if(COLOR_ON)
      {
        if(color_mode == "CHANGE_COLOR")
        {
          
           llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, COL_1 ,1.0]);  
           
        }  
        
         if(GLOW_ON)
        {
        
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, glow_intensity]);  
        
        }
        
        if(GLOW_FADE)
        {
            
          iGlow = 0.0;
          Blend(Forward = TRUE);  
            
        }
        
        
        
         if(LIGHT_ON) 
              { 
                
              
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]); 
               }
               

        if(FULL_BRIGHT)
        {
            
           llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);   
            
        }
        
        else if(!FULL_BRIGHT)
        {
            
           llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);   
            
        }
         
       if(color_mode == "COLOR_FADE" || color_mode == "RAINBOW_FADE" || color_mode == "PASTEL_FADE"|| GLOW_FADE == TRUE || LIGHT_FADE == TRUE || RAINBOW_LIGHT == TRUE || PASTEL_LIGHT == TRUE)  
       { 
       
      
      Blend(Forward = TRUE);
      
       }
      if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE")
      {
       
       Strobe(Forward = TRUE);
       }
      }
    }
    
    touch_end(integer num)
    {
       key toucher = llDetectedKey(0);
       
       if(toucher == owner)
       {
        listening = !listening;
        
        if(listening)
        {   
        
        llOwnerSay("Listening for settings from HUD.");
       llListenRemove(l_handle);
        l_chan = ((integer)("0x"+llGetSubString((string)owner,-8,-1)) - 777) | 0x8000000; 
       l_handle = llListen(l_chan,"","","");  
        }
        
        else
        {
        llListenRemove(l_handle);
        llOwnerSay("Listening off.");
        }
       }
        
    }
    
     listen(integer chan, string name, key id, string msg)
    {
        
      
        if(chan == l_chan)
        {
            
            list tmp = llParseString2List(msg,["|"],[]);
            string cmd = llList2String(tmp,0);
            string ref = llList2String(tmp,1);
            
           
            
            if(cmd == "CHANGE_COLOR")
            {
                COLOR_ON = TRUE;
                lswrite = Write("COLOR_ON",(string)COLOR_ON);
               color_mode = cmd; 
               lswrite = Write("color_mode", color_mode);
               llSetTimerEvent(0.0); 
                integer idx = llListFindList(colors,[llToUpper(ref)]);
                vector vec;
               
               if(idx != -1) 
               vec = llList2Vector(colors,idx+1);
               
               else
               vec = (vector)ref; 
                
               COL_1 = vec; 
               lswrite = Write("COL_1", (string)vec); 
               
               COL_2 = vec;
          lswrite = Write("COL_2",(string)COL_2); 
                
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, vec ,1.0]);
                
                if(GLOW_ON)
        {
        
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, glow_intensity]);  
        
        }
        
        if(GLOW_FADE)
        {
          
          iGlow = 0.0;
          Blend(Forward = TRUE);
            
        }
        
        
        
         if(LIGHT_ON) 
              { 
                
            //  llOwnerSay("turning light on");
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]); 
              llSetTimerEvent(0.0); 
               }
               
             
               
               
              if(LIGHT_FADE == TRUE || RAINBOW_LIGHT == TRUE || PASTEL_LIGHT == TRUE)
             {
              
              Blend(Forward);   
                 
             }  
             
            else if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
{
     llResetTime();
    Fading = TRUE;
    llSetTimerEvent(ui_time);
    Light_Strobe();
    
    }
                
            }
            
            else if(cmd == "COLOR_FADE" || cmd == "RAINBOW_FADE"|| cmd == "PASTEL_FADE")
            {
              
              COLOR_ON = TRUE;  
             lswrite =  Write("COLOR_ON",(string)COLOR_ON);
              llSetTimerEvent(0.0); 
                ridx = 1; 
               lswrite = Write("ridx",(string)ridx);   
            color_mode = cmd; 
            
            lswrite = Write("color_mode", color_mode);
            if(cmd == "COLOR_FADE")
            getColors(ref);
            else if(cmd == "RAINBOW_FADE" || cmd == "PASTEL_FADE")
            {
             
                if (cmd == "RAINBOW_FADE")
                {
               rlength = llGetListLength(rainbow);
                COL_1 = llList2Vector(rainbow,ridx); 
               COL_2 =  llList2Vector(rainbow,ridx+2);
                }
                else if (cmd == "PASTEL_FADE")
                {
               rlength = llGetListLength(pastel); 
                COL_1 = llList2Vector(pastel,ridx); 
               COL_2 =  llList2Vector(pastel,ridx+2);
                }
              
               
                lswrite = Write("COL_1",(string)COL_1); 
                 lswrite = Write("COL_2",(string)COL_2); 
               
              
            }
           
            
            iGlow = 0.0;
            
          
           
           if(GLOW_ON)
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, glow_intensity]);
           
             if(LIGHT_ON) 
               llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]); 
               
               
                Blend(Forward = TRUE);
               
            }
            
            
             else if(cmd == "COLOR_STROBE" || cmd == "RAINBOW_STROBE" || cmd == "PASTEL_STROBE" )
            {
               
                COLOR_ON = TRUE;
               lswrite =  Write("COLOR_ON",(string)COLOR_ON);
                
                if(GLOW_ON == TRUE || GLOW_FADE == TRUE)
                {
                  
                  GLOW_ON = FALSE;
                  GLOW_FADE = FALSE;
                  GLOW_STROBE = TRUE;  
                  lswrite = Write("GLOW_ON",(string)GLOW_ON);
                  lswrite = Write("GLOW_FADE",(string)GLOW_FADE);
                  lswrite = Write("GLOW_STROBE",(string)GLOW_STROBE);
         
                }
                
                
                if(LIGHT_ON == TRUE || LIGHT_FADE == TRUE || RAINBOW_LIGHT == TRUE || PASTEL_LIGHT == TRUE || RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
                {
                  
                  if((LIGHT_ON == TRUE && RAINBOW_LIGHT_STROBE == FALSE) && (LIGHT_ON == TRUE && PASTEL_LIGHT_STROBE == FALSE)){
                 // llOwnerSay("RETURN");
                  LIGHT_ON = TRUE;}
                  else
                  LIGHT_ON = FALSE;
                  LIGHT_FADE = FALSE;
                  if(RAINBOW_LIGHT_STROBE == TRUE)
                  {
                      
                     
                     LIGHT_STROBE = FALSE; 
                    RAINBOW_LIGHT_STROBE = TRUE; 
                    PASTEL_LIGHT_STROBE = TRUE; 
                  }
                  
                  else if(PASTEL_LIGHT_STROBE == TRUE)
                  {
                      
                     LIGHT_STROBE = FALSE;  
                    RAINBOW_LIGHT_STROBE = FALSE; 
                    PASTEL_LIGHT_STROBE = TRUE; 
                  }
                  
                  else
                  {
                       
    
                  if(RAINBOW_LIGHT == TRUE || PASTEL_LIGHT == TRUE)
                  LIGHT_STROBE =FALSE;


                  else     
                  LIGHT_STROBE = TRUE; 
                  RAINBOW_LIGHT_STROBE = FALSE; 
                  PASTEL_LIGHT_STROBE = FALSE; 
                  } 
                  lswrite = Write("LIGHT_ON",(string)LIGHT_ON);
                  lswrite = Write("LIGHT_FADE",(string)LIGHT_FADE);
                  lswrite = Write("LIGHT_STROBE",(string)LIGHT_STROBE);
                   lswrite = Write("RAINBOW_LIGHT_STROBE",(string)RAINBOW_LIGHT_STROBE);  
                    lswrite = Write("PASTEL_LIGHT_STROBE",(string)PASTEL_LIGHT_STROBE); 
         
                }
                
              llSetTimerEvent(0.0);   
            color_mode = cmd; 
            lswrite = Write("color_mode", color_mode);
            ridx = 1;
            if(cmd == "COLOR_STROBE")
            getColors(ref);        
            else if(cmd == "RAINBOW_STROBE")
            {
             rlength = llGetListLength(rainbow);     
            COL_1 = llList2Vector(rainbow,ridx);
            }
            else if(cmd == "PASTEL_STROBE")
            {
            rlength = llGetListLength(pastel);    
            COL_1 = llList2Vector(pastel,ridx);
            }
           
            STROBE = COL_1;
          
           Strobe(Forward = TRUE);
               
            }
            
            else if(cmd == "GLOW_ON")
            {
              if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE") 
              {
              GLOW_ON = FALSE;
              GLOW_FADE = FALSE;  
              GLOW_STROBE = TRUE;    
              }
              
              else
              {
              GLOW_ON = TRUE;
              GLOW_FADE = FALSE;  
              GLOW_STROBE = FALSE;   
                  
              } 
               
              lswrite = Write("GLOW_ON",(string)GLOW_ON);
              lswrite = Write("GLOW_FADE",(string)GLOW_FADE);
              lswrite = Write("GLOW_STROBE",(string)GLOW_STROBE);
              llOwnerSay("Glow On."); 
              llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, glow_intensity]); 
                
            }
            
            else if(cmd == "GLOW_OFF")
            {
              GLOW_ON = FALSE;
              GLOW_FADE = FALSE;
              GLOW_STROBE = FALSE;  
              lswrite = Write("GLOW_ON",(string)GLOW_ON);
              lswrite = Write("GLOW_FADE",(string)GLOW_FADE);
              lswrite = Write("GLOW_STROBE",(string)GLOW_STROBE); 
              llOwnerSay("Glow OFF.");  
              llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, 0.0]);
                
            }
            
             else if(cmd == "GLOW_FADE_ON")
            {
               llSetTimerEvent(0.0);  
              if(color_mode =="COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE") 
              {
              GLOW_ON = FALSE;
              GLOW_FADE = FALSE;  
              GLOW_STROBE = TRUE;    
              }
              
              else
              {
              GLOW_ON = FALSE;
              GLOW_FADE = TRUE;  
              GLOW_STROBE = FALSE;   
                  
              } 
               
              lswrite = Write("GLOW_ON",(string)GLOW_ON);
              lswrite = Write("GLOW_FADE",(string)GLOW_FADE);
              lswrite = Write("GLOW_STROBE",(string)GLOW_STROBE);
              
              
           
              
              llOwnerSay("Glow Fade On."); 
            
              if(COLOR_ON) 
              {
                 iGlow = 0.0;
                 llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, glow_intensity]);   
               Blend(Forward);
               }
               else
               llOwnerSay("Switch color on to see the glow."); 
            }
            
            else if(cmd == "GLOW_FADE_OFF")
            {
              GLOW_ON = FALSE;
              GLOW_FADE = FALSE;
              GLOW_STROBE = FALSE;  
              lswrite = Write("GLOW_ON",(string)GLOW_ON);
              lswrite = Write("GLOW_FADE",(string)GLOW_FADE);
              lswrite = Write("GLOW_STROBE",(string)GLOW_STROBE); 
              llOwnerSay("Glow Fade OFF.");  
              llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, 0.0]);
                
            }
            
            
            
            
            else if(cmd  == "LIGHT_ON")
            {
               
               LIGHT_ON = TRUE;
              LIGHT_FADE = FALSE; 
              
               LIGHT_STROBE = FALSE;
              RAINBOW_LIGHT = FALSE;
              PASTEL_LIGHT = FALSE;
               RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
              
              if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE")
             {
                LIGHT_ON = FALSE; 
                 LIGHT_FADE = FALSE; 
                LIGHT_STROBE = TRUE; 
             }
              
            lswrite = Write("LIGHT_ON",(string)LIGHT_ON);
            lswrite = Write("LIGHT_STROBE",(string)LIGHT_STROBE);
              lswrite = Write("LIGHT_FADE",(string)LIGHT_FADE);
               lswrite = Write("RAINBOW_LIGHT_STROBE",(string)RAINBOW_LIGHT_STROBE);
              lswrite = Write("PASTEL_LIGHT_STROBE",(string)PASTEL_LIGHT_STROBE);
              lswrite = Write("RAINBOW_LIGHT",(string)RAINBOW_LIGHT);
              lswrite = Write("PASTEL_LIGHT",(string)PASTEL_LIGHT);
            
              
              integer idx = llListFindList(colors,[llToUpper(ref)]);
                vector vec;
               
               if(idx != -1) 
               vec = llList2Vector(colors,idx+1);
               
               else
               vec = (vector)ref; 
               
               LIGHT_1 = vec;
               lswrite = Write("LIGHT_1",(string)vec);
               
               LIGHT_2 = vec;
               lswrite = Write("LIGHT_2",(string)vec);
              
              if(COLOR_ON) 
              { 
                llOwnerSay("Light On");
              
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, vec, light_intensity,light_radius,light_falloff]); 
               }
               
               else
               {
                   llOwnerSay("Turn Color on to see the light.");
                  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, FALSE, BLACK, light_intensity,light_radius,light_falloff]);   
                }
                
             //  llOwnerSay("Light on:" + (string)LIGHT_ON);
               
               if(color_mode == "CHANGE_COLOR")
               llSetTimerEvent(0.0);
                
            }
            
            
             else if(cmd == "LIGHT_FADE_ON" || cmd == "RAINBOW_LIGHT_FADE" || cmd == "PASTEL_LIGHT_FADE" || cmd == "RAINBOW_LIGHT_STROBE" || cmd == "PASTEL_LIGHT_STROBE")
            {
               llSetTimerEvent(0.0);
                ridx = 1; 
               lswrite = Write("ridx",(string)ridx);  
              if(color_mode =="COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE") 
              {
               
              LIGHT_ON = FALSE;
              LIGHT_FADE = FALSE; 
              
              if(LIGHT_STROBE == TRUE)
              LIGHT_STROBE = TRUE;
              else
              LIGHT_STROBE = FALSE;  
              RAINBOW_LIGHT = FALSE;
              PASTEL_LIGHT = FALSE;
              if(cmd == "LIGHT_FADE_ON")
              {
              LIGHT_STROBE = TRUE;
              PASTEL_STROBE = FALSE;
              RAINBOW_STROBE = FALSE; // PRIM COLOR
              RAINBOW_LIGHT_STROBE =FALSE;
              PASTEL_LIGHT_STROBE =FALSE;
             // llOwnerSay(" cmd == LIGHT_FADE_ON Light Strobe is true");
              }   
              else if(cmd == "RAINBOW_LIGHT_FADE") 
              {
                  
              LIGHT_STROBE = FALSE;  
              PASTEL_STROBE = FALSE;   
              RAINBOW_STROBE = TRUE;
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
                PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = TRUE;
              
            //  llOwnerSay("light strobe is false");
              
              }
               else if(cmd == "PASTEL_LIGHT_FADE") 
              {
                 
              LIGHT_STROBE = FALSE;     
              PASTEL_STROBE = TRUE;
              RAINBOW_STROBE = FALSE;
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
                PASTEL_LIGHT = TRUE;   
              RAINBOW_LIGHT = FALSE;
              
              
              
              }
              
              
               else if(cmd == "RAINBOW_LIGHT_STROBE") 
              {
                   
              LIGHT_STROBE = FALSE;  
              RAINBOW_LIGHT_STROBE = TRUE;
              PASTEL_LIGHT_STROBE = FALSE;
             //  llOwnerSay("prim strobing");
              }
               else if(cmd == "PASTEL_LIGHT_STROBE") 
              {
                  
              LIGHT_STROBE = FALSE;     
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = TRUE;
              }
              
               
              if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE")
             {
                LIGHT_ON = FALSE; 
                 LIGHT_FADE = FALSE; 
                 
                LIGHT_STROBE = TRUE; 
             }
              } // if prim color strobing
              
              else   // prim fading or on one colour
              {
              
              LIGHT_ON = FALSE;
              if(cmd == "LIGHT_FADE_ON")
              { 
                  
              LIGHT_FADE = TRUE; 
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = FALSE;
                RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
              } 
              else if(cmd == "RAINBOW_LIGHT_FADE")
              {
                  
                 
              LIGHT_FADE = FALSE; 
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = TRUE;
               RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
              } 
               else if(cmd == "PASTEL_LIGHT_FADE")
              {
              
              LIGHT_FADE = FALSE; 
              PASTEL_LIGHT = TRUE;   
              RAINBOW_LIGHT = FALSE;
               RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
                
              } 
              
               else if(cmd == "RAINBOW_LIGHT_STROBE")
              {
                
              LIGHT_FADE = FALSE; 
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = FALSE;
              RAINBOW_LIGHT_STROBE = TRUE;
              PASTEL_LIGHT_STROBE = FALSE;
           //    llOwnerSay("prim fading");
              } 
               else if(cmd == "PASTEL_LIGHT_STROBE")
              {
               
              LIGHT_FADE = FALSE; 
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = FALSE;
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = TRUE;
              } 
              
              
              LIGHT_STROBE = FALSE;  
              PASTEL_STROBE = FALSE;
              RAINBOW_STROBE = FALSE;    
              }  // prim fading or on one colour
               
             
              
             if(cmd == "LIGHT_FADE_ON")
             {
                 LIGHT_ON = FALSE;
                 
                LIGHT_STROBE = FALSE;
              //  llOwnerSay("prim not fading light strobe false");
                 LIGHT_FADE = TRUE;
                  
              if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE")
             {
                LIGHT_ON = FALSE; 
                 LIGHT_FADE = FALSE; 
                LIGHT_STROBE = TRUE; 
             }
                 
                PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = FALSE;
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE; 
              
              LIGHT_STROBE = FALSE;  
            getLights(ref);
              llOwnerSay("Light Fade On."); 
             }
             
              if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE" && cmd == "LIGHT_FADE_ON")
             {
                LIGHT_ON = FALSE; 
                LIGHT_STROBE = TRUE; 
             }
           
           
            else if(cmd == "RAINBOW_LIGHT_FADE" || cmd == "PASTEL_LIGHT_FADE" || cmd == "RAINBOW_LIGHT_STROBE" || cmd == "PASTEL_LIGHT_STROBE")
            {
              
              
              LIGHT_ON = FALSE;
              LIGHT_FADE = FALSE; 
              LIGHT_STROBE = FALSE;
              
                if (cmd == "RAINBOW_LIGHT_FADE")
                {
                  LIGHT_STROBE = FALSE;
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = TRUE;
               RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;  
              //  llOwnerSay("rainbow light");    
               rlength = llGetListLength(rainbow);
                LIGHT_1 = llList2Vector(rainbow,ridx); 
               LIGHT_2 =  llList2Vector(rainbow,ridx+2);
                llOwnerSay("Light Fade On."); 
                }
                else if (cmd == "PASTEL_LIGHT_FADE")
                {
                   LIGHT_STROBE = FALSE; 
              PASTEL_LIGHT = TRUE;   
              RAINBOW_LIGHT = FALSE;
               RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;  
                 // llOwnerSay("pastel light");    
               rlength = llGetListLength(pastel); 
                LIGHT_1 = llList2Vector(pastel,ridx); 
               LIGHT_2 =  llList2Vector(pastel,ridx+2);
                llOwnerSay("Light Fade On."); 
                }
                
                else if (cmd == "RAINBOW_LIGHT_STROBE")
                {
              LIGHT_STROBE = FALSE;     
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = FALSE;
              RAINBOW_LIGHT_STROBE = TRUE;
              PASTEL_LIGHT_STROBE = FALSE;  
                    
                 //   llOwnerSay("rlightstrobe "  + (string)RAINBOW_LIGHT_STROBE);
               // llOwnerSay("rainbow light STROBE");    
               rlength = llGetListLength(rainbow);
                LIGHT_1 = llList2Vector(rainbow,ridx); 
               LIGHT_2 =  llList2Vector(rainbow,ridx+2);
                llOwnerSay("Light Strobe On."); 
                }
                else if (cmd == "PASTEL_LIGHT_STROBE")
                {
                    LIGHT_STROBE = FALSE;  
              PASTEL_LIGHT = FALSE;   
              RAINBOW_LIGHT = FALSE;
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = TRUE; 
                    
                 // llOwnerSay("pastel light STROBE");    
               rlength = llGetListLength(pastel); 
                LIGHT_1 = llList2Vector(pastel,ridx); 
               LIGHT_2 =  llList2Vector(pastel,ridx+2);
                llOwnerSay("Light Strobe On."); 
                }
              
               
                
            }
             
            
              
             
            
              if(COLOR_ON) 
              {
                 iGlow = 0.0;
                  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]); 
               Blend(Forward);
               }
               else
               llOwnerSay("Switch color on to see the light.");
               
               
              lswrite = Write("LIGHT_1",(string)LIGHT_1); 
                 lswrite = Write("LIGHT_2",(string)LIGHT_2); 
                 
                 
                 lswrite = Write("LIGHT_ON",(string)LIGHT_ON);
              lswrite = Write("LIGHT_FADE",(string)LIGHT_FADE);
              lswrite = Write("LIGHT_STROBE",(string)LIGHT_STROBE);
               lswrite = Write("RAINBOW_LIGHT_STROBE",(string)RAINBOW_LIGHT_STROBE);
              lswrite = Write("PASTEL_LIGHT_STROBE",(string)PASTEL_LIGHT_STROBE);
              lswrite = Write("RAINBOW_LIGHT",(string)RAINBOW_LIGHT);
              lswrite = Write("PASTEL_LIGHT",(string)PASTEL_LIGHT);
              lswrite = Write("RAINBOW_STROBE",(string)RAINBOW_STROBE);
              lswrite = Write("PASTEL_STROBE",(string)PASTEL_STROBE);  
               
                
            }
            
             else if(cmd  == "LIGHT_OFF")
            {
                
                LIGHT_ON = FALSE;
              LIGHT_FADE = FALSE;
              
              LIGHT_STROBE = FALSE;
              RAINBOW_LIGHT = FALSE;
              PASTEL_LIGHT = FALSE;
              RAINBOW_STROBE = FALSE;
              PASTEL_STROBE = FALSE;
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;
           
              
              
              
             lswrite = Write("LIGHT_ON",(string)LIGHT_ON); 
             lswrite = Write("LIGHT_FADE",(string)LIGHT_FADE); 
             lswrite = Write("LIGHT_STROBE",(string)LIGHT_STROBE);
              lswrite = Write("RAINBOW_LIGHT",(string)RAINBOW_LIGHT);
              lswrite = Write("PASTEL_LIGHT",(string)PASTEL_LIGHT);
              lswrite = Write("RAINBOW_LIGHT_STROBE",(string)RAINBOW_LIGHT_STROBE);
              lswrite = Write("PASTEL_LIGHT_STROBE",(string)PASTEL_LIGHT_STROBE);
              lswrite = Write("RAINBOW_STROBE",(string)RAINBOW_STROBE);
              lswrite = Write("PASTEL_STROBE",(string)PASTEL_STROBE);
              
               llOwnerSay("Light Off"); 
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);
                
            }
            
            else if(cmd == "LIGHT_FADE_OFF" || cmd == "RAINBOW_LIGHT_OFF" || cmd == "PASTEL_LIGHT_OFF")
            {
                
                 LIGHT_ON = FALSE;
              LIGHT_FADE = FALSE;  
              LIGHT_STROBE = FALSE;   
              RAINBOW_LIGHT = FALSE;
              PASTEL_LIGHT = FALSE; 
              RAINBOW_LIGHT_STROBE = FALSE;
              PASTEL_LIGHT_STROBE = FALSE;   
             
               
              lswrite = Write("LIGHT_ON",(string)LIGHT_ON);
              lswrite = Write("LIGHT_FADE",(string)LIGHT_FADE);
              lswrite = Write("LIGHT_STROBE",(string)LIGHT_STROBE);
              lswrite = Write("RAINBOW_LIGHT",(string)RAINBOW_LIGHT);
              lswrite = Write("PASTEL_LIGHT",(string)PASTEL_LIGHT);
              lswrite = Write("RAINBOW_LIGHT_STROBE",(string)RAINBOW_LIGHT_STROBE);
              lswrite = Write("PASTEL_LIGHT_STROBE",(string)PASTEL_LIGHT_STROBE); 
               
            
           
            
              
               llOwnerSay("Light Off"); 
                 llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, FALSE, BLACK, light_intensity,light_radius,light_falloff]);   
                
            }
            
            
            
            else if(cmd == "SWITCH_OFF")
            {
                llSetTimerEvent(0.0);
                COLOR_ON = FALSE;
                GLOW_ON = FALSE;
                GLOW_STROBE = FALSE;
                GLOW_FADE = FALSE;
                LIGHT_ON = FALSE;
                LIGHT_FADE = FALSE; 
                 LIGHT_STROBE = FALSE; 
                RAINBOW_LIGHT_STROBE = FALSE;
                PASTEL_LIGHT_STROBE = FALSE; 
                FULL_BRIGHT = FALSE; 
                 
                 
              RAINBOW_LIGHT = FALSE;
              PASTEL_LIGHT = FALSE;
              RAINBOW_STROBE = FALSE;
              PASTEL_STROBE = FALSE;
           
            
              lswrite = Write("RAINBOW_LIGHT",(string)RAINBOW_LIGHT);
              lswrite = Write("PASTEL_LIGHT",(string)PASTEL_LIGHT);
              lswrite = Write("RAINBOW_STROBE",(string)RAINBOW_STROBE);
              lswrite = Write("PASTEL_STROBE",(string)PASTEL_STROBE);
                
                 lswrite = Write("COLOR_ON",(string)COLOR_ON);
                 lswrite = Write("GLOW_ON",(string)GLOW_ON);
                 lswrite = Write("GLOW_STROBE",(string)GLOW_STROBE);
                 lswrite = Write("GLOW_FADE",(string)GLOW_FADE);
                 lswrite = Write("LIGHT_ON",(string)LIGHT_ON);
                 lswrite = Write("LIGHT_FADE",(string)LIGHT_FADE);
                 lswrite = Write("LIGHT_STROBE",(string)LIGHT_STROBE);
                  lswrite = Write("RAINBOW_LIGHT_STROBE",(string)RAINBOW_LIGHT_STROBE);
              lswrite = Write("PASTEL_LIGHT_STROBE",(string)PASTEL_LIGHT_STROBE); 
              lswrite = Write("full_bright",(string)FULL_BRIGHT); 
                
                 llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, ALL_SIDES, BLACK ,1.0,PRIM_GLOW,ALL_SIDES,0.0,PRIM_GLOW,ALL_SIDES,0.0, PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01,PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                
                llOwnerSay("Off.");
                
               
                
            }
            
             else if(cmd == "Fade_Time")
            {
              fade_time = (float)ref;  
              if(fade_time == 0.0)
              fade_time = 0.1;
               llOwnerSay("Fade time set to " + llGetSubString((string)fade_time,0,3) + " seconds");  
             lswrite = Write("Fade_Time",(string)fade_time + "seconds.");
            }
            
            else if(cmd == "Wait_Time")
            {
              wait_time = (float)ref; 
              if(wait_time == 0.0)
              wait_time = 0.1;
              llOwnerSay("Wait time set to " + llGetSubString((string)wait_time,0,3) + " seconds."); 
              lswrite = Write("Wait_Time",(string)wait_time);  
            }
            
            else if(cmd =="GLOW_INTENSITY")
            {
                
              glow_intensity = (float)ref;
              
              if(glow_intensity > 1.0)
              glow_intensity = 1.0;
              
              lswrite = Write("glow_intensity",(string)glow_intensity);
              
              if(GLOW_ON == TRUE || GLOW_FADE == TRUE || GLOW_STROBE == TRUE)
             {
                 
                 
                llSetLinkPrimitiveParams(LINK_THIS,[PRIM_GLOW,ALL_SIDES, glow_intensity]);    
                 
                
             }  
                
            }
            
             else if(cmd =="LIGHT_INTENSITY")
            {
                 llOwnerSay("Light intensity set to " + (string)ref);
              light_intensity = (float)ref;
              
              if(light_intensity > 1.0)
              light_intensity = 1.0;
              
              lswrite = Write("light_intensity",(string)light_intensity);

             if(LIGHT_ON) 
               llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);
                  
            }
           
            else if(cmd =="LIGHT_RADIUS")
            {
                llOwnerSay("Light radius set to " + (string)ref);
              light_radius = (float)ref;
              
              if(light_radius > 20.0)
              light_radius = 20.0;
              
              lswrite = Write("light_radius",(string)light_radius);
              
               if(LIGHT_ON) 
               llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);
                  
            }
            
             else if(cmd =="LIGHT_FALLOFF")
            {
                 llOwnerSay("Light falloff set to " + (string)ref);
              light_falloff = (float)ref;
              
              if(light_falloff > 2.0)
              light_falloff = 2.0;
              
              lswrite = Write("light_falloff",(string)light_falloff);
              
               if(LIGHT_ON) 
               llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);
                  
            }
            
            
             else if(cmd =="FULL_BRIGHT")
            {
                
                if(FULL_BRIGHT)
                {
                
                 llOwnerSay("Full bright off.");
                 FULL_BRIGHT = FALSE;
                  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);  
                
                }
                
                 else if(!FULL_BRIGHT)
                {
                
                 llOwnerSay("Full bright on.");
                 FULL_BRIGHT = TRUE;
                  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);  
                
                }
              
              
             
              
              lswrite = Write("full_bright",(string)FULL_BRIGHT);
              
              
                  
            }
            
           
            
        }
            
            
    }
    
    
     changed(integer change)
    {
        
     if(change & CHANGED_OWNER)
     {
       
       llResetScript();  
         
     }   
        
    }

   timer()
   {
  // llOwnerSay("get time is " + (string)llGetTime());
 
   
    if( (color_mode == "CHANGE_COLOR"  && RAINBOW_LIGHT_STROBE == TRUE)   || (color_mode ==  "CHANGE_COLOR"  && PASTEL_LIGHT_STROBE == TRUE))
{
    
   // llOwnerSay("timer light off");
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);
   llSleep(wait_time);
   
  // llOwnerSay((string)wait_time);
}

    if(COLOR_ON == FALSE && GLOW_FADE == FALSE && GLOW_STROBE == FALSE && LIGHT_FADE == FALSE && RAINBOW_LIGHT == FALSE  && PASTEL_LIGHT == FALSE)  
     {
       
       llSetTimerEvent(0.0);  
         
     }
     
     
     else if(COLOR_ON == TRUE || GLOW_FADE == TRUE ||  LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE )  
     {
        if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE) {
     //llOwnerSay("fading: " + (string)Fading);
 //   llOwnerSay((string)RAINBOW_LIGHT_STROBE + " "+(string)PASTEL_LIGHT_STROBE + "light off" );
         llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]); 

} 
        
      float a = llGetTime() / fade_time; 
    //  llOwnerSay("llGetTime() / fade_time;");
       if(Fading)
        {
            
          
          if(COLOR_ON)
           { 
            if((color_mode == "COLOR_FADE" || color_mode == "RAINBOW_FADE" || color_mode == "PASTEL_FADE") )
            { 
                  // OwnerSay("color fading");
            llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_COLOR, ALL_SIDES,    a * End + (1-a) * Start, 1.0 ]);
                
                 
               
             }
               
            } // color on   
          
           if(GLOW_FADE)
              {
                 
                iGlow = glow_intensity - (2*a) * glow_intensity; 
                if(iGlow <= 0.0)
                {
                iGlow = 0.0 + a * glow_intensity; 
               
                } 
                
              llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES,iGlow]);
              } //   if(GLOW_FADE)
              
              if(LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE)
            { 
                  
                    // llOwnerSay("Light Fade " + (string)LIGHT_FADE);
 //llOwnerSay("RAINBOW_LIGHT " + (string)RAINBOW_LIGHT);
 // llOwnerSay("PASTEL_LIGHT " + (string)PASTEL_LIGHT);
                    /// llOwnerSay("lStart" + (string)lStart + "lEnd" + (string)lEnd); 
         
             //   llOwnerSay("if(LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE)");
             llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE,  a * lEnd + (1-a) * lStart, light_intensity,light_radius,light_falloff]); 
                  
               
             }   //  if(LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE)

          if((color_mode == "COLOR_STROBE" && RAINBOW_LIGHT == TRUE)  ||(color_mode == "COLOR_STROBE" && PASTEL_LIGHT == TRUE))
            { 
                    
          
                
            // llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE,  a * lEnd + (1-a) * lStart, light_intensity,light_radius,light_falloff]); 
                  
               
             }   //  if(LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE)
               
              
              if(a >= 1.0)
            {
                
             //  llOwnerSay("a >= 1.0");
                Fading = FALSE;
                
                if(color_mode == "COLOR_FADE")
            { //llOwnerSay("color end" + (string)End);
                llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_COLOR, ALL_SIDES, End, 1.0 ]);
            }
            
          if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
          {
             if(color_mode == "CHANGE_COLOR")
             { 
             ridx += 2;
           if(ridx >= rlength)
            ridx=1;
           //  llOwnerSay("fading change color "+(string)ridx);
           lswrite = Write("ridx",(string)ridx);
           }
            
            
             if(RAINBOW_LIGHT_STROBE == TRUE)
             {
                
                // llOwnerSay("fading gonna rainbow light strobe");  
      LIGHT_1 = llList2Vector(rainbow,ridx);
      lswrite = Write("LIGHT_1", (string)LIGHT_1);
      
     //  llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);

 Light_Strobe();
              }
    else if(PASTEL_LIGHT_STROBE == TRUE)
    {// llOwnerSay("gonna pastel light strobe");  
      LIGHT_1 = llList2Vector(pastel,ridx);
      lswrite = Write("LIGHT_1", (string)LIGHT_1);
      
      // llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);

 Light_Strobe();
      } 
              
              
         }  //  if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
            
              if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE")
            {
              //  llOwnerSay("CHANGING COLOR");
                llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_COLOR, ALL_SIDES, STROBE, 1.0 ]);
                 if(GLOW_STROBE)
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, glow_intensity]);
                
               if((color_mode == "COLOR_STROBE" && RAINBOW_LIGHT == TRUE) ||(color_mode == "COLOR_STROBE" && PASTEL_LIGHT== TRUE))
              {
                 
                   ridx += 2;
    if(ridx >= rlength)
    ridx = 1;
 
      // lswrite = Write("ridx",(string)ridx);
    
     
                }

                 if(LIGHT_STROBE == TRUE) {
                    
                     
                    if(lStrobe){
                      //  llOwnerSay("strobe true");
               llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_1, light_intensity,light_radius,light_falloff]);}
                    else {
                        // llOwnerSay("strobe false");
               llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE, LIGHT_2, light_intensity,light_radius,light_falloff]); }     
} 
            } 
             //  if(color_mode == "COLOR_STROBE" || color_mode  == "RAINBOW_STROBE" || color_mode  == "PASTEL_STROBE")
            
            
             if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
     {
        // llOwnerSay("lights off");
      // llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);
 
     
           //  if( LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE)
           // llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT, TRUE,  lEnd, light_intensity,light_radius,light_falloff]); 
                 
                
        }
       
            llSetTimerEvent(wait_time);
            
            }    //  if(a >= 1.0)  
            
                  
            
            } // fading 
    
        else
        {
          //  llOwnerSay("not fading");
          //  llOwnerSay(color_mode);
          
          // llOwnerSay("LIGHT_FADE " + color_mode );
         // llOwnerSay("LIGHT_FADE " + (string)LIGHT_FADE );
         //  llOwnerSay("GLOW_FADE " + (string)GLOW_FADE );
          // llOwnerSay("RAINBOW_LIGHT " + (string)RAINBOW_LIGHT );
          //  llOwnerSay("PASTEL_LIGHT " + (string)PASTEL_LIGHT );
          //   llOwnerSay("RAINBOW_LIGHT_STROBE " + (string)RAINBOW_LIGHT_STROBE );
           // llOwnerSay("PASTEL_LIGHT_STROBE " + (string)PASTEL_LIGHT_STROBE );
                 
       if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
     {
        // llOwnerSay("not fading rainbow strobing light");
       llSetLinkPrimitiveParamsFast(LINK_THIS,[ PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);  
      
     // llOwnerSay("not fading light off");
      
     } // if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)    
          //   if((color_mode == "CHANGE_COLOR" && color_mode == "RAINBOW_FADE")||(color_mode == "CHANGE_COLOR" && color_mode == "PASTEL_FADE")){llOwnerSay("not fading rainbow fading");}   
//if color mode is not blending or color maybe
// find out why changing to red and then fading to next color
     //  llOwnerSay("color mode is " + color_mode);
    //   llSetLinkPrimitiveParamsFast(LINK_THIS,[  PRIM_COLOR, ALL_SIDES, BLACK ,1.0,PRIM_GLOW,ALL_SIDES,0.0]); 

  if( (color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE" && RAINBOW_LIGHT == TRUE) || (color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE" && PASTEL_LIGHT == TRUE))
{
  
 // llOwnerSay("prim strobing and light fading");
  
  if(color_mode == "RAINBOW_STROBE" )
      COL_1 = llList2Vector(rainbow,ridx);
    else if(color_mode == "PASTEL_STROBE")
      COL_1 = llList2Vector(pastel,ridx);
    lswrite = Write("COL_1", (string)COL_1);  
    
     if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
     {
   //    llSetLinkPrimitiveParamsFast(LINK_THIS,[ PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);  
     // llOwnerSay("not fading light strobe");
      Light_Strobe(); 
      
     } // if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
   
     if((color_mode == "COLOR_STROBE"  && RAINBOW_LIGHT == TRUE) ||(color_mode == "COLOR_STROBE"  && PASTEL_LIGHT == TRUE))
   {
      if(color_mode == "RAINBOW_STROBE" )
      COL_1 = llList2Vector(rainbow,ridx);
    else if(color_mode == "PASTEL_STROBE")
      COL_1 = llList2Vector(pastel,ridx);
    lswrite = Write("COL_1", (string)COL_1);  
    Strobe(Forward); 
     
     }
    
    if( (color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE"  && RAINBOW_LIGHT == TRUE) ||(color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE"  && PASTEL_LIGHT == TRUE))
{    


 ridx += 2;
    if(ridx >= rlength)
    ridx = 1;
  
      // lswrite = Write("ridx",(string)ridx);
    
    if(color_mode == "RAINBOW_STROBE" )
      COL_1 = llList2Vector(rainbow,ridx);
    else if(color_mode == "PASTEL_STROBE")
      COL_1 = llList2Vector(pastel,ridx);
    lswrite = Write("COL_1", (string)COL_1);  
    Strobe(Forward); 
   }  //  if( color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE")
  
    
}

          
            if( color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE"|| RAINBOW_LIGHT_STROBE == TRUE  || PASTEL_LIGHT_STROBE == TRUE && RAINBOW_LIGHT == FALSE && PASTEL_LIGHT == FALSE && color_mode != "RAINBOW_FADE" && color_mode != "PASTEL_FADE")
  { 
        
    ridx += 2;
    if(ridx >= rlength)
    ridx = 1;
 
      // lswrite = Write("ridx",(string)ridx);
 
    
    if(color_mode == "RAINBOW_STROBE" )
      COL_1 = llList2Vector(rainbow,ridx);
    else if(color_mode == "PASTEL_STROBE")
      COL_1 = llList2Vector(pastel,ridx);
     if(LIGHT_STROBE == TRUE){
          
    lStrobe = ! lStrobe;
   // llOwnerSay("Light strobe is " + (string)LIGHT_STROBE);
    Light_Strobe(); }
    lswrite = Write("COL_1", (string)COL_1); 
   
  // llOwnerSay("Light strobe is " + (string)LIGHT_STROBE);
     
    
    if( color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE")
{    
//llOwnerSay("Light strobe is " + (string)LIGHT_STROBE);
    Strobe(Forward = !Forward); 
   }  //  if( color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE")
        
          
   }  // if( color_mode == "COLOR_STROBE" || color_mode == "RAINBOW_STROBE"|| color_mode == "PASTEL_STROBE"|| RAINBOW_LIGHT_STROBE == TRUE  || PASTEL_LIGHT_STROBE == TRUE)


  if(color_mode == "COLOR_FADE"  || color_mode == "RAINBOW_FADE"|| color_mode == "PASTEL_FADE"  ||GLOW_FADE == TRUE || LIGHT_FADE == TRUE || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE)
           {
             if((color_mode == "CHANGE_COLOR" ||color_mode == "COLOR_FADE" || color_mode == "RAINBOW_FADE"|| color_mode == "PASTEL_FADE" && RAINBOW_LIGHT == TRUE)  || (color_mode == "CHANGE_COLOR" ||color_mode == "COLOR_FADE" || color_mode == "RAINBOW_FADE"|| color_mode == "PASTEL_FADE" && PASTEL_LIGHT == TRUE) || (color_mode == "RAINBOW_FADE" && LIGHT_FADE == FALSE && RAINBOW_LIGHT == FALSE && PASTEL_LIGHT == FALSE)|| (color_mode == "PASTEL_FADE" && LIGHT_FADE == FALSE && RAINBOW_LIGHT == FALSE && PASTEL_LIGHT == FALSE)|| (color_mode == "RAINBOW_FADE" && LIGHT_FADE == TRUE && RAINBOW_LIGHT == FALSE && PASTEL_LIGHT == FALSE)|| (color_mode == "PASTEL_FADE" && LIGHT_FADE == TRUE && RAINBOW_LIGHT == FALSE && PASTEL_LIGHT == FALSE))
            {  
                ridx += 2;
           if(ridx >= rlength)
            ridx=1;
           
            lswrite = Write("ridx",(string)ridx);
            }
            
    // llOwnerSay((string)COL_1);
    //  llOwnerSay((string)COL_2);
     // llOwnerSay((string)RAINBOW_LIGHT);
     // llOwnerSay((string)PASTEL_LIGHT);
      
   
             Blend(Forward = !Forward);
               
             
          } 



                     
    //  if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
    // {
   //    llSetLinkPrimitiveParamsFast(LINK_THIS,[ PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,0.0,0.1,0.01]);  
   //  llOwnerSay("not fading " + (string)ridx);
     // llOwnerSay("not fading light strobe");
    //  Light_Strobe(); 
      
    // } // if(RAINBOW_LIGHT_STROBE == TRUE || PASTEL_LIGHT_STROBE == TRUE)
     
    //   llOwnerSay("timer end");
            
        } // else not fading
       
        }//  else if(COLOR_ON == TRUE || GLOW_FADE == TRUE ||  LIGHT_FADE == TRUE  || RAINBOW_LIGHT == TRUE  || PASTEL_LIGHT == TRUE )
        
      
      
      }  // timer

}
