{
  var z    = 255;
  var out  = [];
  var next = 4;
  var dict = {};

  function build() {
    out = out.map(function(b) {
      if(typeof b != 'string')
        return b;

      if(b in dict)
        return dict[b];
 
      console.error('Unknown label "' + b + '"');
      return 0;
    });

    return out;
  }

  function add_label(name) {
    dict[name] = next;
  }
 
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

  function gen_jmp(c) {
    out = out.concat([z, z, c]);
  }

  function gen_inc(a, c) {
    var out = [];

    out = out.concat([next + 5, a, next]);
    next += 3;
    out = out.concat([z, z, next + 1]);
    out = out.push(255);
    next += 4;

    return out;
  }

  function gen_mov(a, b, c) {
    step(b, b);
    step(a, z);
    step(z, b);
    step(z, z, c);
  }
}

prgm
  = (stmt '\n')+ { return build(); }

stmt
  = label
  / insn
  / comment

label
  = s:str ':' { add_label(s); }

comment
  = '#' [^\n]+

insn
  = mov
  / add
  / data
  / jmp

data
  = "DATA " n:num { out.push(n) }

mov
  = "MOV " a:id ", " b:id c:(", " i:id { return i })?
  { return gen_mov(a, b, c) }

add
  = "ADD " a:id ", " b:id c:(", " i:id { return i })?
  { return gen_add(a, b, c) }

add
  = "INC " a:id
  { return gen_inc(a); }

jmp
  = "JMP " a:id { return gen_jmp(a) }

id
  = num
  / str

str
  = f:[_a-zA-Z] r:[_a-zA-Z0-9]* { return f + r.join(''); }

num
  = d:[0-9]+ { return parseInt(d.join('')) }
