task foo {
  command {
    touch foo
  }
  output {
    File foo = "foo"
  }
  runtime {
    docker: "ubuntu:latest"
  }
}

task bar {
  File foo
  String otherFile = foo + ".foo"
  command {
    gzip ${foo}
    echo -n "${foo}.gz"
  }
  output {
    File bar = "${foo}.gz"
    File bar2 = read_string(stdout())

  }
  runtime {
    docker: "ubuntu:latest"
  }
}

task baz {
  File bar
  command {
    echo "Got ${bar}"
  }
  runtime {
    docker: "ubuntu:latest"
  }
}

workflow passing_files {
  call foo
  call bar { input: foo = foo.foo }
  call baz { input: bar = bar.bar }
}
