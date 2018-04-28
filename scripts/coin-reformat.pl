#!/usr/bin/env perl

use strict;

my %config = ();
$config{MPSTAT} = { header_regex => 'CPU +%user +%nice +%sys +%iowait +%irq +%soft +%steal +%idle +intr\/s',
                    columns => [ { name => 'CPU',     size =>  3 },
                                 { name => '%user',   size =>  7 },
                                 { name => '%nice',   size =>  7 },
                                 { name => '%sys',    size =>  7 },
                                 { name => '%iowait', size =>  7 },
                                 { name => '%irq',    size =>  7 },
                                 { name => '%soft',   size =>  7 },
                                 { name => '%steal',  size =>  7 },
                                 { name => '%idle',   size =>  7 },
                                 { name => 'intr/s',  size => 10 } ],
                    parser => \&parse_line_sysstat };

$config{MPSTAT_V9} = { header_regex => 'CPU +%usr +%nice +%sys +%iowait +%irq +%soft +%steal +%guest +%idle',
                       columns => [ { name => 'CPU',     size =>  3 },
                                    { name => '%usr',    size =>  7 },
                                    { name => '%nice',   size =>  7 },
                                    { name => '%sys',    size =>  7 },
                                    { name => '%iowait', size =>  7 },
                                    { name => '%irq',    size =>  7 },
                                    { name => '%soft',   size =>  7 },
                                    { name => '%steal',  size =>  7 },
                                    { name => '%guest',  size =>  7 },
                                    { name => '%idle',   size =>  7 } ],
                       parser => \&parse_line_sysstat };

$config{MPSTAT_V10} = { header_regex => 'CPU +%usr +%nice +%sys +%iowait +%irq +%soft +%steal +%guest +%gnice +%idle',
                        columns => [ { name => 'CPU',     size =>  3 },
                                     { name => '%usr',    size =>  7 },
                                     { name => '%nice',   size =>  7 },
                                     { name => '%sys',    size =>  7 },
                                     { name => '%iowait', size =>  7 },
                                     { name => '%irq',    size =>  7 },
                                     { name => '%soft',   size =>  7 },
                                     { name => '%steal',  size =>  7 },
                                     { name => '%guest',  size =>  7 },
                                     { name => '%gnice',  size =>  7 },
                                     { name => '%idle',   size =>  7 } ],
                        parser => \&parse_line_sysstat };

$config{IOSTAT} = { header_regex => 'Device: +rrqm\/s +wrqm\/s +r\/s +w\/s +rkB\/s +wkB\/s +avgrq-sz +avgqu-sz +await +svctm +%util',
                    columns => [ { name => 'Device:',  size => 12 },
                                 { name => 'rrqm/s',   size => 10 },
                                 { name => 'wrqm/s',   size => 10 },
                                 { name => 'r/s',      size => 10 },
                                 { name => 'w/s',      size => 10 },
                                 { name => 'rkB/s',    size => 10 },
                                 { name => 'wkB/s',    size => 10 },
                                 { name => 'avgrq-sz', size => 10 },
                                 { name => 'avgqu-sz', size => 10 },
                                 { name => 'await',    size => 10 },
                                 { name => 'svctm',    size => 10 },
                                 { name => '%util',    size =>  7 } ],
                    parser => \&parse_line_sysstat };

$config{IOSTAT_V10} = { header_regex => 'Device: +rrqm\/s +wrqm\/s +r\/s +w\/s +rkB\/s +wkB\/s +avgrq-sz +avgqu-sz +await +r_await +w_await +svctm +%util',
                        columns => [ { name => 'Device:',  size => 12 },
                                     { name => 'rrqm/s',   size => 10 },
                                     { name => 'wrqm/s',   size => 10 },
                                     { name => 'r/s',      size => 10 },
                                     { name => 'w/s',      size => 10 },
                                     { name => 'rkB/s',    size => 10 },
                                     { name => 'wkB/s',    size => 10 },
                                     { name => 'avgrq-sz', size => 10 },
                                     { name => 'avgqu-sz', size => 10 },
                                     { name => 'await',    size => 10 },
                                     { name => 'r_await',  size => 10 },
                                     { name => 'w_await',  size => 10 },
                                     { name => 'svctm',    size => 10 },
                                     { name => '%util',    size =>  7 } ],
                        parser => \&parse_line_sysstat };

$config{IOSTAT_X} = { header_regex => 'Device: +rrqm\/s +wrqm\/s +r\/s +w\/s +rsec\/s +wsec\/s +avgrq-sz +avgqu-sz +await +svctm +%util',
                      columns => [ { name => 'Device:',  size => 12 },
                                   { name => 'rrqm/s',   size => 10 },
                                   { name => 'wrqm/s',   size => 10 },
                                   { name => 'r/s',      size => 10 },
                                   { name => 'w/s',      size => 10 },
                                   { name => 'rsec/s',   size => 10 },
                                   { name => 'wsec/s',   size => 10 },
                                   { name => 'avgrq-sz', size => 10 },
                                   { name => 'avgqu-sz', size => 10 },
                                   { name => 'await',    size => 10 },
                                   { name => 'svctm',    size => 10 },
                                   { name => '%util',    size =>  7 } ],
                      parser => \&parse_line_sysstat };

$config{MEMINFO} = { columns => [ { name => 'name',  size => 20 },
                                  { name => 'value', size => 20 } ],
                     parser => \&parse_line_meminfo };

$config{NETSTAT} = { columns => [ { name => 'Iface',  size => 8 },
                                  { name => 'RX packets',  size => 16 },
                                  { name => 'RX errors',   size => 16 },
                                  { name => 'RX dropped',  size => 16 },
                                  { name => 'RX overruns', size => 16 },
                                  { name => 'RX bytes',    size => 20 },
                                  { name => 'TX packets',  size => 16 },
                                  { name => 'TX errors',   size => 16 },
                                  { name => 'TX dropped',  size => 16 },
                                  { name => 'TX overruns', size => 16 },
                                  { name => 'TX bytes',    size => 20 } ],
                     parser => \&parse_line_netstat };

sub column_names
{
  my ($config) = @_;
  my @columns = @{$config->{columns}};

  return map { $_->{name} } @columns;
}

sub column_sizes
{
  my ($config) = @_;
  my @columns = @{$config->{columns}};

  return map { $_->{size} } @columns;
}

sub column_count
{
  my ($config) = @_;
  my @columns = @{$config->{columns}};
  my $count = @columns;

  return $count;
}

sub row_format
{
  my ($config) = @_;
  my @sizes = column_sizes($config);

  return join ' ', (map { '%-' . $_ . 's' } @sizes);
}

sub header_str
{
  my ($config) = @_;

  return sprintf(row_format($config), column_names($config));
}

sub row_sep_str
{
  my ($config) = @_;
  my @sizes = column_sizes($config);

  return join ' ', (map { '-' x $_ } @sizes);
}

sub print_header
{
  my ($config) = @_;

  print "CNAME            CTIMESTAMP              ";
  print header_str($config);
  print "\n";
  print "---------------- ----------------------- ";
  print row_sep_str($config);
  print "\n";
}

sub parse_line_sysstat
{
  my ($config, $line) = @_;
  my @values = ();

  @values = split(/ +/, $line);

  return if $#values + 1 < column_count($config) + 2;
  return if defined($config->{header_regex}) && $_ =~ /$config->{header_regex}/;
  return if $values[0] eq "MPSTAT" && $values[2] eq "Average:";

  return sprintf(row_format($config), @values[-(column_count($config))..-1]);
}

sub parse_line_meminfo
{
  my ($config, $line) = @_;
  my @values = ();

  @values = split(/ +/, $line);

  return if $values[2] =~ /INFO/;

  $values[2] =~ s/:$//;
  return sprintf(row_format($config), @values[2..3]);
}

{
  my %netstat = ( Iface => "",
                  'RX packets'  => 0,
                  'RX errors'   => 0,
                  'RX dropped'  => 0,
                  'RX overruns' => 0,
                  'RX bytes'    => 0,
                  'TX packets'  => 0,
                  'TX errors'   => 0,
                  'TX dropped'  => 0,
                  'TX overruns' => 0,
                  'TX bytes'    => 0 );

  sub parse_line_netstat
  {
    my ($config, $line) = @_;
    my @values = ();

    @values = split(/ +/, $line);

    unless (substr($line, 28, 1) =~ /\s/)
    {
      $netstat{Iface} = $values[2];
    }

    if ($line =~ /(RX|TX) packets:(\d+) errors:(\d+) dropped:(\d+) overruns:(\d+)/)
    {
      my $rt = $1;
      $netstat{$rt . ' packets'}  = $2;
      $netstat{$rt . ' errors'}   = $3;
      $netstat{$rt . ' dropped'}  = $4;
      $netstat{$rt . ' overruns'} = $5;
    }

    if ($line =~ /RX bytes:(\d+) .* TX bytes:(\d+) /)
    {
      $netstat{'RX bytes'} = $1;
      $netstat{'TX bytes'} = $2;
      return sprintf(row_format($config), @netstat{column_names($config)});
    }

    return;
  }
}

@ARGV = map { /\.(gz|Z)$/ ? "gzip -dc $_ |" : $_ } @ARGV;

my $cname = "";
my $config;
my $argv = "";
while (<>)
{
  my $ctimestamp = "";
  my $print_line = "";
  chomp;

  if (/^(\S+) (\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d)/)
  {
    if ($cname ne $1)
    {
      print "\n";
      $cname = $1;
      $config = $config{$cname};
      print_header($config) unless ($cname eq 'MPSTAT' || $cname eq 'IOSTAT');
    }
    $ctimestamp = $2;
  }

  if ($cname eq 'MPSTAT' || $cname eq 'IOSTAT')
  {
    foreach my $mpstat ('MPSTAT', 'MPSTAT_V9', 'MPSTAT_V10', 'IOSTAT', 'IOSTAT_V10', 'IOSTAT_X')
    {
      if (/$config{$mpstat}->{header_regex}/)
      {
        $config = $config{$mpstat};
        if ($argv ne $ARGV)
        {
          $argv = $ARGV;
          print_header($config);
        }
      }
    }
  }

  $print_line = $config->{parser}->($config, $_);

  if ($print_line ne "")
  {
    printf("%-16s %-23s ", $cname, $ctimestamp);
    print $print_line;
    print "\n";
  }
}
