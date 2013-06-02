{
  var z    = 255;
  var out  = [];
  var next = 4;
  
  function step(a, b, c) {
    if(typeof c == 'number')
      next = c;

    out   = out.concat([a, b, next]);
    next += 3;
  }
  
  function gen_add(a, b, c) {
    step(a, z);
    step(z, b);
    step(z, z, c);
  }

  function gen_mov(a, b, c) {
    step(b, b);
    step(a, z);
    step(z, b);
    step(z, z, c);
  }
}

prgm
  = is:(i:insn '\n' { return i })+ { return out; }

insn
  = mov
  / add
  / data
  / jmp

data
  = "DATA " n:num { out.push(n) }

mov
  = "MOV " a:num ", " b:num c:(", " i:num { return i })?
  { gen_mov(a, b, c) }

add
  = "ADD " a:num ", " b:num c:(", " i:num { return i })?
  { gen_add(a, b, c) }

jmp
  = "JMP " a:num { step(z, z, a) }

num = d:[0-9]+ { return parseInt(d.join('')) }
