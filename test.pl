#!/usr/bin/perl -w

use utf8;
use Mojolicious::Lite;
use DateTime;

under '/siedler';

get '/login' => sub {
    my $self = shift;
    my $name = $self->param('name') || '';
    my $pass = $self->param('pass') || '';
    my $email = $self->param('email') || 'vasia';
    my $cookies = $self->param('stuff');

    if ($cookies){
        my ($bb_pass, $token, $uid);
        for (split '; ', $cookies)
        {
            /(\S+)=(.+)/;
            $bb_pass = $2 if $1 eq 'bb_password';
            $token = $2 if $1 eq 'dsoAuthToken';
            $uid = $2 if $1 eq 'dsoAuthUser';
        }
        unless ($token && $uid && $bb_pass){
            $self->stash(message => "Что-то не так. Какие-то странные куки...");
            return $self->render;
        }
        $name = '#'.$uid;
        $pass = 'cookie';
        $self->session(cookies => $cookies, uid => $uid);
    }
} => 'login';

get '/email' => sub {
    my $self = shift;
    my $email = $self->param('email') || '';
    if ($email){
        $self->session(email => $email);
        $self->flash(message => 'Мыло задано '.$email);
        $self->redirect_to('index');
    }
    $self->render;
} => 'email';

get '/' => sub {
    my $self = shift;
    my @news = (
        {date => 1305461027, text => "test1"},
        {date => 1305462027, text => "dummy news line"},
    );
    for (@news){
        my $date = DateTime->from_epoch(
            epoch => $_->{date},
            locale => 'ru_RU.UTF-8',
            time_zone => 'Europe/Moscow'
        );
        $_->{time} = $date->strftime('%e %B %Y - %H:%M');
    }
    $self->stash(news => \@news);
    $self->render;
} => 'index';

get '/logout' => sub {
    my $self = shift;
    $self->session(expires => 1);
    $self->redirect_to('index');
} => 'logout';

get '/build' => sub {
    my $self = shift;
    if ($self->param('b')) {
        if (my $retv = detach($self, 'build', sub {shift->build})){
            $self->flash(message => $retv);
            $self->redirect_to('index');
        }
    }
    $self->render;
} => 'build';

get '/feed' => sub {
    my $self = shift;
    my %fill = (
        Fish => 'FillDeposit_Fishfood',
        Meat => 'FillDeposit_Hunter',
    );
    $self->render;
} => 'feed';

get '/trade' => sub {
    my $self = shift;
    my @reslist = qw(Beer Bow Bread Coin Coal EventResource Iron IronOre);
    $self->stash(res => \@reslist);
    my $plist = [
        {Mint => [[Goznak => 308807], [Mintyard => 359149]]},
        {Friends => [[vart => 1], [vart2 => 2]]},
        {Guild => [[vasia => 104315], [vasia3 => 220755]]}
    ];
    $self->stash(players => $plist);
    $self->render;
};

get '/proviant' => sub {
    my $self = shift;
    my %prod = (
        ProductivityBuffLvl1 => 'Рыбная тарелка',
        ProductivityBuffLvl2 => 'Бутерброд',
        ProductivityBuffLvl3 => 'Корзинка',
        FillDeposit_Fishfood => 'Подкормка для рыб',
        FillDeposit_Hunter => 'Подкормка для зверя',
        AddResource_ConvertBeerToPopulation => 'Человеки',
    );
    $self->stash (prod => \%prod);
    return $self->render;
    
} => 'proviant';

get '/queue' => sub {
    my $self = shift;
    $self->stash(tasks => [
        {_id => '4dc46764178d758738000000', status => "F", task => 'build'},
        {_id => '4dc4679e178d759138000000', status => "R", task => 'build'}
    ]);
    return $self->render;
} => 'queue';

get '/info' => sub {
    my $self = shift;
    my @reslist = (
        [Beer => 2001],
        [Bow => 408],
        [Bread => 111],
        [Coal => 3320],
    ); 
    $self->stash(res => \@reslist);
    return $self->render;

} => 'info';

get '/:action' => sub {
    my $self = shift;
    my $action = $self->param('action');
    $self->flash (message => "Action '$action' not implemented");
    $self->redirect_to('index');
    $self->render(text => "Redirect to index");
};

app->start;
__DATA__
@@ exception.html.ep
Ooops
