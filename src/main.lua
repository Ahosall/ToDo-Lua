dirname = debug.getinfo(1, "S").source:sub(3):match(".*[/\\]"):gsub('[/\\]', '.') or ""

local ToDo = require(dirname .. "utils.ToDo")
local Utils = require(dirname .. "utils.utils")

function listTasks(dataTasks, finished)
  tasks = {}
  finished = finished or false

  print('Task list:')
  for idx, task in ipairs(dataTasks) do
    if finished == true then
      table.insert(tasks, "  #" .. task.id .. " | " .. task.title .. "\n    - " .. task.description)
    else
      if task.finished == false then
        table.insert(tasks, "  #" .. task.id .. " | " .. task.title .. "\n    - " .. task.description)
      end
    end
  end

  if #tasks > 0 then
    for idx, task in ipairs(tasks) do
      print(task)
    end
  else
    print("  No tasks registered or incomplete")
  end
end

function deleteTask()
  Utils.clear()
  if #ToDo:list() > 0 then
    listTasks(ToDo.tasks)

    print("\nSelect a task:")
    local id = tonumber(Utils.input("  Task ID (#n): "))

    if not (id == nil) then
      local tasks = ToDo:list(id)
      if #tasks > 0 then
        ToDo:remove(id)
      end
    end
  end
end

function updateTask()
  Utils.clear()
  if #ToDo:list() > 0 then
    listTasks(ToDo.tasks)

    print("\nSelect a task to update:")
    local id = tonumber(Utils.input("  Task ID (#n): "))

    if not (id == nil) then
      local tasks = ToDo:list(id)
      if #tasks > 0 then
        Utils.clear()
        local task = tasks[1]

        print("Task #" .. task.id)
        print("  Title: " .. task.title)
        print("  Description: " .. task.description)

        print('\nEdit:')
        local title = Utils.input("  Title: ")
        local description = Utils.input("  Description: ")
        local finished = Utils.input("  Finished (y/N): ")

        if title:gsub("[%s]+", "") == "" then
          title = task.title
        end

        if description:gsub("[%s]+", "") == "" then
          description = task.description
        end

        if finished:lower():sub(1, 1) == 'y' then
          finished = true
        else
          finished = false
        end

        ToDo:update(task.id, {
          title = title,
          description = description,
          finished = finished
        })
      end
    end
  end
end

function createTask()
  Utils.clear()
  print("Create a new task")
  local title = Utils.input("  Title: ")
  local description = Utils.input("  Description: ")

  if not (title:gsub("[%s]+", "") == "") and not (description:gsub("[%s]+", "") == "") then
    ToDo:create(title, description)
  end
end

function main()
  while true do
    Utils.clear()
    listTasks(ToDo.tasks)

    print("\nMenu:")
    local items = {"Create", "Update", "Delete"}
    for idx, key in ipairs(items) do
      print("  [" .. idx .. "]: " .. key)
    end
    print("  [0]: Exit")

    local choice = tonumber(Utils.input("\n:> "))

    -- switch statement
    local func = ({
      [1] = createTask,
      [2] = updateTask,
      [3] = deleteTask
    })[tonumber(choice)];

    if func then
      func()
    else
      os.exit()
    end
  end
end

main()
