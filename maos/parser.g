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
    var p = next;
    if(typeof c == 'number')
      p = c;

    out   = out.concat([a, b, p]);
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
    out = out.concat([next + 5, a, next]);
    next += 3;
    out = out.concat([z, z, next + 1, 255]);
    next += 4;
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
  = "DATA " n:id { out.push(n); ++next; }

mov
  = "MOV " a:id ", " b:id c:(", " i:id { return i })?
  { gen_mov(a, b, c) }

add
  = "ADD " a:id ", " b:id c:(", " i:id { return i })?
  { gen_add(a, b, c) }

add
  = "INC " a:id
  { gen_inc(a); }

jmp
  = "JMP " a:id { gen_jmp(a) }

id
  = num
  / str

str
  = f:[_a-zA-Z] r:[_a-zA-Z0-9]* { return f + r.join(''); }

num
  = d:[0-9]+ { return parseInt(d.join('')) }
