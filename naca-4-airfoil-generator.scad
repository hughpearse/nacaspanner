/*
 * OpenScad script to generate upper and lower airfoil
 * values based on 4-digit series NACA codes, spanning 1m
 * Author: Hugh Pearse
 */ 
c = 1;//chord length
t = 0.1;//thickness
p = 0.4;//location of max camber
m = 0.04;//max camber
pc = 0.4;//location of max camber, normalized

x_increment = 0.01;
pi = 3.141592653589793238;

function calc_y(t,c,x) = t/0.2*c*(0.2969*sqrt(x/c)-0.126*(x/c)-0.3516*pow((x/c),2)+0.2843*pow((x/c),3)-0.1015*pow((x/c),4));

function calc_y_c(x,pc,m,c,p) = x>=pc ? 
        (m*(c-x)/(pow((1-p),2))*(1+x/c-2*p)) : 
        (m*x/(pow(p,2))*(2*p-x/c));

function calc_y_c_next(x,pc,m,c,p,x_increment) = x>=pc ? 
        (m*(c-x)/(pow((1-p),2))*(1+x/c-2*p)) : 
        (m*(x+x_increment)/(pow(p,2))*(2*p-(x+x_increment)/c));

function calc_theta(y_c_next,y_c,x,x_increment) = atan((y_c_next-y_c)/((x+x_increment)-x)) * (pi / 180);

function calc_x_upper(x,y,theta) = x-y*sin(theta);

function calc_y_upper(y_c,y,theta) = y_c+y*cos(theta);

function calc_x_lower(x,y,theta) = x+y*sin(theta);

function calc_y_lower(y_c,y,theta) = y_c-y*cos(theta);

function upper_point(x) = [
    calc_x_upper(
        x,
        calc_y(t,c,x),
        calc_theta(calc_y_c_next(x,pc,m,c,p,x_increment),calc_y_c(x,pc,m,c,p),x,x_increment)
    ),
    calc_y_upper(
        calc_y_c(x,pc,m,c,p),
        calc_y(t,c,x),
        calc_theta(calc_y_c_next(x,pc,m,c,p,x_increment),calc_y_c(x,pc,m,c,p),x,x_increment)
    )
];

function lower_point(x) = [
    calc_x_lower(
        x,
        calc_y(t,c,x),
        calc_theta(calc_y_c_next(x,pc,m,c,p,x_increment),calc_y_c(x,pc,m,c,p),x,x_increment)
    ),
    calc_y_lower(
        calc_y_c(x,pc,m,c,p),
        calc_y(t,c,x),
        calc_theta(calc_y_c_next(x,pc,m,c,p,x_increment),calc_y_c(x,pc,m,c,p),x,x_increment)
    )
];

function upper_points(void) = [for (x=[0.0 : x_increment : 1.0]) upper_point(x)];

function lower_points(void) = [for (x=[0.0 : x_increment : 1.0]) lower_point(x)];

upper_points_array = upper_points();
lower_points_array = lower_points();

airfoil = concat(upper_points_array, lower_points_array);

polygon(points = airfoil);
echo(airfoil);

