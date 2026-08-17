#ifndef SHELL_H
#define SHELL_H

void shell_main(void);
void shell_prompt(void);
int  shell_parse_command(const char *cmd);

#endif /* SHELL_H */
