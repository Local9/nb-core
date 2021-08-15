
com.lua.utils.Text.Generator = ESX.GetRandomString


com.lua.utils.Text.Split = function (s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end