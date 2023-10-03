local function up_if_blank_line()
    if console.getcursorpos and settings.get("clink.logo") == "none" then
        local x, y = console.getcursorpos()
        if y > 1 and console.getlinetext(y - 1) == "" then
            clink.print("\x1b[A", NONL)
        end
    end
end

clink.oninject(up_if_blank_line)

-- load(io.popen('aliae init cmd'):read("*a"))()
load(io.popen('aliae init cmd'):read("*a"))()