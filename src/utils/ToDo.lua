ToDo = {
  tasks = {}
}

function ToDo:create(title, description)
  local tasks = ToDo:list()
  local lastTaskId = 0
  if #tasks > 0 then
    lastTaskId = tasks[#tasks].id
  end

  local newInstance = {
    id = lastTaskId + 1,
    title = title,
    description = description,
    finished = false
  }

  table.insert(ToDo.tasks, newInstance)
  return newInstance
end

function ToDo:list(id)
  todos = {}

  for idx, task in ipairs(ToDo.tasks) do
    if not (id == nil) then
      if task.id == id then
        table.insert(todos, task)
        break
      end
    else
      table.insert(todos, task)
    end
  end
  return todos
end

function ToDo:update(id, data)
  local todo = ToDo:list(id)[1]

  if not (todo == nil) and not (data == nil) then
    local modInstance = todo
    modInstance.title = data.title or todo.title
    modInstance.description = data.description or todo.description
    modInstance.finished = data.finished or todo.finished

    for idx, t in ipairs(ToDo.tasks) do
      if t.id == id then
        ToDo.tasks[idx] = modInstance
        break
      end
    end
    return modInstance
  end
  return nil
end

function ToDo:remove(id)
  if id == nil then
    return false
  end

  for idx, task in ipairs(ToDo.tasks) do
    if task.id == id then
      table.remove(ToDo.tasks, idx)
      return true
    end
  end
  return false
end

return ToDo
