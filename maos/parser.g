{
  var z    = 255;
  var next = 4;
  var dict = {};

  function build(stmts) {
    var bytes = [].concat.apply([], stmts);

    bytes = bytes.map(function(b) {
      if(typeof b != 'string')
        return b;
 
      if(b in dict)
        return dict[b];
 
      console.error('Unknown label "' + b + '"');
      return 0;
    });

    return bytes;
  }

  function add_label(name) {
    dict[name] = next;
  }
 
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
  = is:(i:stmt '\n' { return i })+ { return build(is); }

stmt
  = label { return [] }
  / insn

label
  = s:str ':' { add_label(s); }

insn
  = mov
  / add
  / data
  / jmp

data
  = "DATA " n:num { return [n] }

mov
  = "MOV " a:id ", " b:id c:(", " i:id { return i })?
  { return gen_mov(a, b, c) }

add
  = "ADD " a:id ", " b:id c:(", " i:id { return i })?
  { return gen_add(a, b, c) }

jmp
  = "JMP " a:id { return gen_jmp(a) }

id
  = num
  / str

str
  = f:[_a-zA-Z] r:[_a-zA-Z0-9]* { return f + r.join(''); }

num
  = d:[0-9]+ { return parseInt(d.join('')) }
