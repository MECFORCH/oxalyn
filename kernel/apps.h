#ifndef APPS_H
#define APPS_H

#define MAX_APPS 16

typedef struct {
    const char *name;
    const char *desc;
    void (*entry)(void);
    int installed;
} AppPackage;

void apps_init(void);
void app_list(void);
int  app_launch(const char *name);
int  app_install(const char *name);

#endif /* APPS_H */
