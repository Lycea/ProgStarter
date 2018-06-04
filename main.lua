ui = require("SimpleUI.SimpleUI")


local gr = love.graphics



local screen_width,screen_height


local show_log = true
--each group has an own table, it has a button and the list of programms plus their paths
--[[
-name
--button id
--programms
---prog name
---prog path
]]
local groups = {num = 0,start_y = 130,y_off = 0}
local selected_group = 0

local text = {}
local log_size = 40
local button_ti = {}



function print(txt)
  if #text>=log_size then
    table.remove(text,log_size)
  end
  
  table.insert(text,1,txt)
end

  


local function addGroup()
  if groups.num < 19 then
    --add new group button
    groups["Group_"..groups.num+1] = {}
    groups["Group_"..groups.num+1].id =ui.AddButton("Group_"..groups.num+1,10,groups.start_y+groups.y_off,100,20)
    groups.num = groups.num +1
    groups.y_off = groups.y_off +32
  else
    print("Reached max group number!!")
  end
end


local col_ns = {0,0,0,1}
local col_s = {1,0,0,1}

local function button_cb(id,type_,label)
  local time_ = love.timer.getTime()
  if button_ti[id] == nil then

  elseif button_ti[id]+0.25< time_ then
    
  else
    return
  end
  
  if id == 2 then
    show_log = not show_log
  
  elseif id == 1 then
    addGroup()
  else
    print("I'm group "..id-2 .." "..label)
    if groups[label] ~=nil then
      --reset the old color
      if selected_group ~= 0 then
        ui.SetColor(groups[selected_group].id,"default_color",col_ns)
      end
      
      selected_group = label
      ui.SetColor(id,"default_color",col_s)
      --set the color of it
    end
    
  end
  
  --print(button_ti[id]or 0 .. " new: "..time_)
  print("Button "..id.." was clicked...")
  button_ti[id] = time_
end
  
 local os_ 
function love.load()
--os.execute("mkdir " .. "profile")
  --set the debugger and other cmd arguments
  for i ,argu in ipairs(arg) do
      --print (argu)
      if argu == "-debug" then
        require("mobdebug").start()   
      end
  end
  
  screen_width,screen_height = gr.getWidth(),gr.getHeight()
  
  ui.init()
  ui.AddClickHandle(button_cb)
  
 
  -- create the ui
  
  main_menue = {
    ui.AddButton("Add group",10,10,90,40,0),

    --           det, pos x           ,pos y, w  ,h ,min,max
    --ui.AddSlider("0",0,300,200,30,0,1),
    
    ui.AddCheckbox("show log",10,70,true)
  }

  ui.AddGroup(main_menue,"menue")
  ui.SetGroupVisible("menue",true)
  
  os_ = love.system.getOS()
  print(os_)
end






function love.update(dt)
  ui.update()
end


function love.draw()
  --reset colors and stuff before drawing a canvas... else it will take that color as kind of a bitmask for the channels
   love.graphics.setBlendMode("alpha")
   love.graphics.setColor(255, 255, 255, 255)
    
    
    
   --draw a line for menue and overview !
   gr.line(0,100,screen_width,100)
  
  if show_log then
    --for later uses change it to check the width of a line and concat it manually
    gr.line(798,100,798,screen_height)
    gr.print(table.concat(text,"\n"),800,100)
  end
  
  
   ui.draw()
end


function love.keypressed(key,code)
  if key == "q" then
      maj,min,pat,code = love.getVersion()
      if  maj == 0 and min >= 10 and pat >= 2 then
       print("reset supported")
       love.event.quit("restart")
      else
       print("reset not supported")
      end
  end
end

function love.mousepressed(x,y,but,touch)
 

end

function love.mousemoved(x,y,dx,dy,tou)
 
end

function love.mousereleased(x,y,but)
 
end

function love.quit()
-- save the groups and stuff here
print("bye bye !!")
end
local windows="\\"
local linux  ="/"

function love.filedropped(file)
  --always set to the selected group
  local repl 
  if os_ == "Linux" then
    repl = linux
  else
    repl = windows
  end
  
  
    print(file:getFilename())
    local path = file:getFilename()
    local name =string.match(path,".+"..repl.."(.+)%.")
    
    --no file ending found so it is a file without :P
    if name == nil then
      name = string.match(path,".+"..repl.."(.+)")
    end
    
    print(name)
    
    if selected_group == 0 then
      print("Please select a group first!")
      return
    end
    
    --add it to the group
    
end

