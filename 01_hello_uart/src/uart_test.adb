with Ada.Text_IO;
with System.Text_IO;
with Setup_Pll;

procedure Uart_Test is
begin
   loop
      Ada.Text_IO.Put_Line ("Hello!");
      delay 1.0;
   end loop;
end Uart_Test;
