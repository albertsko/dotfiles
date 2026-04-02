function diffy
    diff -u "$argv[1]" "$argv[2]" | delta --side-by-side
end
