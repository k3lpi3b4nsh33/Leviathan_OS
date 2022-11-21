/**
 * @file diyfunc.cpp
 * @author l3vi4th4n (k3lpi3b4nsh33@dnmx.org)
 * @brief  DIYFUNC
 * @version 0.1
 * @date 2022-11-16
 * 
 * @copyright Copyright (c) 2022
 * 
 */

void _strwrite(char *str){

    char *p_strdst = (char*)(0xb8000); // Display Address
    while(*str){
        *p_strdst = *str ++;
        p_strdst += 2;
    }
    return;
}

void printf(char* fmt, ...){
    _strwrite(fmt);
    return;
}