-- 将 Emoji 候选延后到首页之后，避免占用首页候选位。
local M = {}

local function codepoints(text)
    local i = 1
    return function()
        if i > #text then return nil end

        local b1 = text:byte(i)
        local cp
        if b1 < 0x80 then
            cp = b1
            i = i + 1
        elseif b1 < 0xE0 then
            local b2 = text:byte(i + 1)
            cp = (b1 - 0xC0) * 0x40 + (b2 - 0x80)
            i = i + 2
        elseif b1 < 0xF0 then
            local b2, b3 = text:byte(i + 1), text:byte(i + 2)
            cp = (b1 - 0xE0) * 0x1000 + (b2 - 0x80) * 0x40 + (b3 - 0x80)
            i = i + 3
        else
            local b2, b3, b4 = text:byte(i + 1), text:byte(i + 2), text:byte(i + 3)
            cp = (b1 - 0xF0) * 0x40000 + (b2 - 0x80) * 0x1000 + (b3 - 0x80) * 0x40 + (b4 - 0x80)
            i = i + 4
        end
        return cp
    end
end

local function has_emoji(text)
    for cp in codepoints(text) do
        if
            (cp >= 0x1F000 and cp <= 0x1FAFF) or -- Emoji blocks
            (cp >= 0x2600 and cp <= 0x27BF) or   -- Misc Symbols / Dingbats: ❌ ✅ ✔
            (cp >= 0x2B00 and cp <= 0x2BFF) or   -- Arrows / stars used as Emoji
            cp == 0x200D or                       -- ZWJ
            cp == 0xFE0F                          -- emoji variation selector
        then
            return true
        end
    end
    return false
end

function M.init(env)
    local config = env.engine.schema.config
    M.page_size = config:get_int("menu/page_size") or 5
end

function M.func(input)
    local emoji_cands = {}
    local normal_count = 0
    local emitted_emoji = false
    local pass_through = false

    local function emit_emoji()
        if emitted_emoji then return end
        for _, cand in ipairs(emoji_cands) do
            yield(cand)
        end
        emitted_emoji = true
    end

    for cand in input:iter() do
        if pass_through then
            yield(cand)
        elseif has_emoji(cand.text) then
            table.insert(emoji_cands, cand)
        else
            yield(cand)
            normal_count = normal_count + 1
            if normal_count >= M.page_size then
                emit_emoji()
                pass_through = true
            end
        end
    end

    emit_emoji()
end

return M
