package Mojolicious::Command::coverage;
use strict;
use warnings FATAL => 'all';
use Mojo::Base 'Mojolicious::Command', -signatures;
use Mojo::Util qw(getopt);

our $VERSION = "0.0.0"; # Do not update manually

# Short description
has description => 'Start you Mojo app in coverage mode';

# Usage message from SYNOPSIS
has usage => sub($self) {$self->extract_usage};


sub run($self, @args) {
    my $deanonConfig = "";
    my $coverageConfig = "";
    my $n_args = 0;
    my @orig_args = @args;

    getopt \@args,['pass_through'],
        'd|deanon-args=s' => sub {
            $n_args+=2;
            $deanonConfig = $_[1]
        },
        'c|cover-args=s'  => sub {
            $n_args+=2;
            $coverageConfig = $_[1]
        };

    if ($deanonConfig eq "" && $self->app->can('deanonymizeConfig')) {
        $deanonConfig = $self->app->deanonymizeConfig;
        print "Command::coverage: Has deanonymize config \n";
    }

    if ($coverageConfig eq "" && $self->app->can('coverageConfig')) {
        $coverageConfig = $self->app->coverageConfig;
        print "Command::coverage: Has coverage config \n";
    }

    # if there is no custom config, we fallback to default
    $deanonConfig = ref $self->app if $deanonConfig eq "";
    $coverageConfig = "-ignore,t/,-coverage,statement,branch,condition,path,subroutine" if $coverageConfig eq "";

    my $command_line = "";
    my $forwarded_args = join " ", @orig_args[$n_args..$#orig_args];
    if ($coverageConfig ne "0"){
        $command_line = "perl -MDevel::Cover=$coverageConfig -MDevel::Deanonymize=$deanonConfig $0 daemon $forwarded_args";
    } else {
        $command_line = "perl -MDevel::Cover=$coverageConfig $0 daemon $forwarded_args";
    }

    print "Command::coverage: Starting application with: `$command_line`";
    exec $command_line;
}

=head1 NAME

Mojolicious::Command::coverage - Run your application with coverage statistics

=cut

=head1 SYNOPSIS

    Usage: APPLICATION coverage [OPTIONS] [APPLICATION_OPTIONS]

    ./myapp.pl coverage [application arguments]

    Options:
    -h, --help                Shows this help
    -c, --cover-args <args>   Options for Devel::Cover
    -d, --deanon-args <args>  Options for Devel::Deanonymize (set to 0 to disable Devel::Deanonymize)

    Application Options
    - All parameters not matching [OPTIONS] are forwarded to the mojo application


=cut

=head1 DESCRIPTION

Starts your mojo application with L<Devel::Cover> and optionally L<Devel::Deanonymize>.

=cut

=head1 USAGE

Runtime configuration for both modules are either passed through the command-line arguments or by specifying
 C<has> sections in your application:

    has coverageConfig => sub{
        return "-ignore,t/,+ignore,prove,+ignore,thirdparty/,-coverage,statement,branch,condition,path,subroutine";
    };

    has deanonymizeConfig => sub {
        return "<Include-pattern>"
    };

If both are present, command-line args are preferred. Note: Other launch modes than C<daemon> are currently not supported

=cut

=head1 AUTHORS

Since there is a lot of spam flooding my mailbox, I had to put spam filtering in place. If you want to make sure
that your email gets delivered into my mailbox, include C<#im_not_a_bot#> in the B<subject!>
S<Tobias Bossert E<lt>tobib at cpan.orgE<gt>>

=cut

=head1 COPYRIGHT AND LICENSE

MIT License
Copyright (c) 2022 Tobias Bossert
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut

1;