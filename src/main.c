#include <stdio.h>
#include <string.h>

#include <aie_archive-apis.h>

int help(char* name)
{
  printf("ataie -- archive tool for aie\n"
         "usage:  %s <archive-name>\n", name);
  return 1;
}

int main(int argc, char** argv)
{
  aie_Archive arc = aie_ARCNIL;

  if(argc != 2)
    return help(argv[0]);

  if(!strcmp(argv[1], "--help") ||
     !strcmp(argv[1], "-help") ||
     !strcmp(argv[1], "-h"))
    return help(argv[0]);

  arc = aie_arcopen(argv[1], -1, NULL);

  puts("Attempt to read and print archive table...\n");
  for(int i = 0; i < arc.table->unitc; i++) {
    aie_ArcUnit u = aie_arctable_get(arc.table, i);
    printf("%s %zuB\n", u.name, aie_arcsegment_sumsize(u.segments));
  }

  aie_kmarchive(&arc);

  return 0;
}

