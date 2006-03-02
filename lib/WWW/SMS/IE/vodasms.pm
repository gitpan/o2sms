#
# $Id: vodasms.pm 173 2006-03-01 19:52:41Z mackers $

package WWW::SMS::IE::vodasms;

=head1 NAME

WWW::SMS::IE::vodasms - A module to send SMS messages using the website of 
Vodafone Ireland

=head1 SYNOPSIS

  require WWW::SMS::IE::vodasms;

  my $carrier = new WWW::SMS::IE::iesms;

  if ($carrier->login('0871234567', 'password'))
  {
    my $retval = $carrier->send('+353865551234', 'Hello World!');

    if (!$retval)
    {
      print $carrier->error() . "\n";
    }
  }

=head1 DESCRIPTION

L<WWW::SMS::IE::vodasms> is a class to send SMS messages via the command line
using the website of Vodafone Ireland -- http://www.vodafone.ie/

For more information see L<WWW::SMS::IE::iesms>

=cut

use strict;
use warnings;
use vars qw( $VERSION );
$VERSION = '0.01'; 

@WWW::SMS::IE::vodasms::ISA = qw{WWW::SMS::IE::iesms};

use constant LOGIN_START_STEP => 0;
use constant LOGIN_END_STEP => 7;
use constant SEND_START_STEP => 8;
use constant SEND_END_STEP => undef;
use constant REMAINING_MESSAGES_MATCH => 1;
use constant ACTION_FILE => "vodafone.action";
use constant SIMULATED_DELAY_MIN => 10;
use constant SIMULATED_DELAY_MAX => 35;
use constant SIMULATED_DELAY_PERCHAR => 0.25;

sub _init
{
	my $self = shift;

	$self->_log_debug("creating new instance of vodasms carrier");

	$self->_login_start_step(LOGIN_START_STEP);
	$self->_login_end_step(LOGIN_END_STEP);
	$self->_send_start_step(SEND_START_STEP);
	$self->_send_end_step(SEND_END_STEP);
	$self->_remaining_messages_match(REMAINING_MESSAGES_MATCH);
	$self->_action_file(ACTION_FILE);
	$self->_simulated_delay_max(SIMULATED_DELAY_MAX);
	$self->_simulated_delay_min(SIMULATED_DELAY_MIN);
	$self->_simulated_delay_perchar(SIMULATED_DELAY_PERCHAR);

	$self->full_name("Vodafone Ireland");
	$self->domain_name("vodafone.ie");
	$self->config_dir($self->_get_home_dir() . "/.vodafonesms/");
	$self->config_file($self->config_dir() . "config");
	$self->message_file($self->config_dir() . "lastmsg");
	$self->cookie_file($self->config_dir() . ".cookie");
	$self->action_state_file($self->config_dir() . ".state");
}

sub is_vodafone
{
	return 1;
}

=head1 DISCLAIMER

The author accepts no responsibility nor liability for your use of this
software.  Please read the terms and conditions of the website of your mobile
provider before using the program.

=head1 SEE ALSO

L<WWW::SMS::IE::iesms>,
L<WWW::SMS::IE::vodasms>,
L<WWW::SMS::IE::meteorsms> 

L<http://www.mackers.com/projects/o2sms/>

=head1 AUTHOR

David McNamara (me.at.mackers.dot.com)

=head1 COPYRIGHT

Copyright 2000-2006 David McNamara

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
