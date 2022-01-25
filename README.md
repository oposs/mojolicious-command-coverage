# mojolicious_coverage
Start you Mojo app in coverage mode

# SYNOPSIS

```text
Usage: APPLICATION coverage [OPTIONS] [APPLICATION_OPTIONS]

./myapp.pl coverage [application arguments]

Options:
-h, --help                Shows this help
-c, --cover-args <args>   Options for Devel::Cover
-d, --deanon-args <args>  Options for Devel::Deanonymize (set to 0 to disable Devel::Deanonymize)

Application Options
- All parameters not matching [OPTIONS] are forwarded to the mojo application
```

# USAGE

Runtime configuration for both modules are either passed through the command-line arguments or by specifying
`has` sections in your application:

```perl5
has coverageConfig => sub{
    return "-ignore,t/,+ignore,prove,+ignore,thirdparty/,-coverage,statement,branch,condition,path,subroutine";
};

has deanonymizeConfig => sub {
    return "<Include-pattern>"
};
```



If both are present, command-line args are preferred. Note: Other launch modes than C<daemon> are currently not supported
