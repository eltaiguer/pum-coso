void keyPressed ()
{
  if (key == '+') displayMode = (displayMode + 1) > 2 ? 0 : ++displayMode;
  if (key == ' ') bewegungsModus = (bewegungsModus + 1) > 2 ? 0 : ++bewegungsModus;

}


void mousePressed ()
{

  bewegungsModus = (bewegungsModus + 1) > 2 ? 0 : ++bewegungsModus;
}

