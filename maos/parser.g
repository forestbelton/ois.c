{
  var z    = 255;
  var next = 4;
  
  function step(out, a, b) {
    var out = out.concat([a, b, next]);
    
    next += 3;
    return out;
  }
  
  function epi(out, c) {
    next = c === '' ? next : c;
    return step(out, z, z);
  }
  
  function gen_jmp(c) {
    return [z, z, c];
  }
  
  function gen_add(a, b, c) {
    var out = [];
    
    out = step(out, a, z);
    out = step(out, z, b);
    out = epi(out, c);
    
    return out;
  }

  function gen_mov(a, b, c) {
    var out = [];
    
    out = step(out, b, b);
    out = step(out, a, z);
    out = step(out, z, b);
    out = epi(out, c);
    
    return out;
  }
}

prgm
  = is:(i:insn '\n' { return i })+ { return [].concat.apply([], is) }

insn
  = mov
  / add
  / data
  / jmp

data
  = "DATA " n:num { return [n] }

mov
  = "MOV " a:num ", " b:num c:(", " i:num { return i })?
  { return gen_mov(a, b, c) }

add
  = "ADD " a:num ", " b:num c:(", " i:num { return i })?
  { return gen_add(a, b, c) }

jmp
  = "JMP " a:num { return gen_jmp(a) }

num = d:[0-9]+ { return parseInt(d.join('')) }
